module UsersHelper
  def url_for_gravatar(email)
    gravatar_id = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar.php?gravatar_id=#{gravatar_id}"
  end
end
