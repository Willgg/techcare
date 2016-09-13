module UsersHelper
  def translate_collection(array)
    User::SEXE.map do |s|
      [t('activerecord.attributes.user.sexe_option.' + s.downcase), s]
    end
  end
end
