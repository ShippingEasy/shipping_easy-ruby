require "spec_helper"

describe ShippingEasy::Resources::Partner do
  describe ".accounts" do
    it "sends a request with the expected options" do
      ShippingEasy::Resources::Partner.should_receive(:execute_request!)
          .with({relative_path: '/accounts',
                 http_method: :post,
                 payload: {account:
                                {first_name:"Bonita",
                                 last_name:"Yundt",
                                 company_name:"Emard, Becker and Morissette",
                                 email:"heberr@kuhlman.net",
                                 phone_number:"787.128.7490",
                                 address:"97509 Littel Throughway",
                                 address2:"",
                                 state:"AA",
                                 city:"North Marielastad",
                                 postal_code:"46183",
                                 country:"Moldova",
                                 password:"abc123",
                                 subscription_plan_code:"basic",
                                 }
                 }
                },:partner
                )

      ShippingEasy::Resources::Partner.accounts(payload:  {
          account:{
          first_name:"Bonita",
          last_name:"Yundt",
          company_name:"Emard, Becker and Morissette",
          email:"heberr@kuhlman.net",
          phone_number:"787.128.7490",
          address:"97509 Littel Throughway",
          address2:"",
          state:"AA",
          city:"North Marielastad",
          postal_code:"46183",
          country:"Moldova",
          password:"abc123",
          subscription_plan_code:"basic"}})
    end
  end

  describe ".subscription_plans" do
    it "sends a request with the expected options" do
      ShippingEasy::Resources::Partner.should_receive(:execute_request!).with({relative_path: '/subscription_plans',
                                                                               http_method: :get,
                                                                              },:partner)

      ShippingEasy::Resources::Partner.subscription_plans
    end
  end
end