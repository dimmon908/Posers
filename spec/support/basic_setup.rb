def home_kunstvoorwerp
  Kunstvoorwerp.stub(:all){ [create_kunstvoorwerp("First KV"), create_kunstvoorwerp("Second KV"), create_kunstvoorwerp("Thirth KV")] }
  faker_image = double("Image")
  faker_image.stub(:url){ "" }
  Webimage.stub(:find){ faker_image }
end

def create_kunstvoorwerp(title)
  kv = double(title)
  kv.stub(:id).and_return("BLA")
  kv.stub(:title).and_return(title)
  kv.stub(:kunstimage).and_return(nil)
  kv.stub_chain(:user, :intname){ "User" }
  kv.stub_chain(:user, :voornaam){ "User" }
  kv.stub_chain(:user, :achternaam){ "User" }
  kv
end
