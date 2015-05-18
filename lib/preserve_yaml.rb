require "preserve_yaml/version"
require 'psych'

module PreserveYaml
  # http://stackoverflow.com/a/12964176
  # http://stackoverflow.com/a/15343320
  # z poprawkami własnymi żeby działało na psychu shipowanym z ruby2.2
  # więc zapewne na innych nie działa.
  class ToRubyNoMerge < Psych::Visitors::ToRuby
    def revive_hash hash, o
      if o.anchor
        @st[o.anchor] = hash
        hash.instance_variable_set "@_yaml_anchor_name", o.anchor
      end

      o.children.each_slice(2) { |k,v|
        key = accept(k)
        hash[key] = accept(v)
      }
      hash
    end
  end

  class MyYAMLTree < Psych::Visitors::YAMLTree
    class Registrar < Psych::Visitors::YAMLTree::Registrar
      # record object for future, using '@_yaml_anchor_name' rather
      # than object_id if it exists
      def register target, node
        anchor_name = target.instance_variable_get('@_yaml_anchor_name') || target.object_id
        @obj_to_id[target.object_id] = anchor_name
        super
      end

    end

    # check to see if this object has been seen before
    def accept target
      if anchor_name = target.instance_variable_get('@_yaml_anchor_name')
        if @st.key? anchor_name
          oid         = anchor_name
          node        = @st[oid]
          anchor      = oid.to_s
          node.anchor = anchor
          return @emitter.alias anchor
        end
      end
      super
    end

    def visit_String o
      if o == '<<'
        style = Psych::Nodes::Scalar::PLAIN
        tag = nil
        plain = true
        quote = false
        @emitter.scalar o, nil, tag, plain, quote, style
      else
        super
      end
    end

  end
end

def preserve_yaml(io)
  tree = Psych.parse io.read
  data = PreserveYaml::ToRubyNoMerge.create.accept(tree)

  yield data

  builder = PreserveYaml::MyYAMLTree.create
  builder.instance_variable_set :@st, PreserveYaml::MyYAMLTree::Registrar.new
  builder << data
  newtree = builder.tree

  io.rewind
  io.truncate(0)
  io.write(newtree.yaml)
  nil
end
