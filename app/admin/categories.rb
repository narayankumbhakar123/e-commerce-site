ActiveAdmin.register Category do
  
  permit_params :name, :image

  form do |f|
    f.inputs do
      f.input :name
      f.input :image, as: :file
      f.input :created_at, as: :datepicker,
                      datepicker_options: {
                        min_date: "2013-10-8",
                        max_date: "+3D"
                      }
    end
    actions
  end

  index do
    column "Image" do |category|
      image_tag category&.image, style: "width:150px; height:150px;"
    end
    column :name
    column 'checking gems' do |category|
      MathUtils.add(2, 3)
    end
    actions
  end
end
