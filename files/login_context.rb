Contextually.define do
  roles :admin, :user, :visitor

  group :admin, :user, :as => :member

  before :user do
    controller.stub!(:current_user).and_return(:user)
  end
  
  before :visitor do
    controller.stub!(:current_user).and_return(nil)
  end
  
  before :admin do
    controller.stub!(:current_user).and_return(:admin)
  end

  deny_access_to :visitor do
    it("should deny access") { should redirect_to(new_session_url) }
  end
  
  deny_access do
    it("should deny access") { should redirect_to(root_url) }
  end
  
end