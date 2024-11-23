ActiveAdmin.register Page do
  permit_params :title, :content

  form do |f|
    f.inputs "Edit Page Content" do
      f.input :title, input_html: { readonly: true } # Prevent title editing
      f.input :content
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content do |page|
        page.content.html_safe # Render HTML content
      end
    end
  end
end
