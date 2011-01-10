class Views::Quarks::Index < Erector::Widget
  def content
    h1 do
      text 'Listing quarks'
    end
    table do
      tr do
        th do
          text 'Name'
        end
        th do
          text 'Age'
        end
        th do
          text 'Price'
        end
      end
      for quark in @quarks
        tr do
          td do
            text quark.name
          end
          td do
            text quark.age
          end
          td do
            text quark.price
          end
          td do
            rawtext link_to('Show', quark)
          end
          td do
            rawtext link_to('Edit', edit_quark_path(quark))
          end
          td do
            rawtext link_to('Destroy', quark, :confirm => 'Are you sure?', :method => :delete)
          end
        end
      end
    end
    br
    rawtext link_to('New quark', new_quark_path)
  end
end
