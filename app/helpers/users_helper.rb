module UsersHelper
  def translate_collection(array)
    User::SEXE.map do |s|
      [t('activerecord.attributes.user.sexe_option.' + s.downcase), s]
    end
  end

  def round_weight(float)
    if (float % 1) == 0
      float.round(0)
    else
      float
    end
  end
end
