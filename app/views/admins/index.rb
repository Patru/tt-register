# encoding: UTF-8

class Views::Admins::Index < Views::Layouts::SWPage
  def page_title
    'Liste der Administratoren'
  end

  def sw_content
    table do
      thead do
        headers :name, :token, :password, :tournament
      end
      tbody do

      end
    end
    br
    link_to "New Admin", new_admin_path
  end
end