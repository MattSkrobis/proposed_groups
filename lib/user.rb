class User

  def initialize(data_string)
    @user_name = data_string.split(':')[0]
    @friends = data_string.split(':')[1]
    @user_groups = data_string.split(':')[2]
  end
end