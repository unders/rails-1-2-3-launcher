require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  
  as :user, :get => :index do
    it { should respond_with(:success) }
    it { should render_template('index') }
  end

  as :visitor, :get => :index do
    it("should deny access") { should redirect_to(new_session_url) }
  end
end