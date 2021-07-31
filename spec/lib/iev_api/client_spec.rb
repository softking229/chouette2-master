# require 'spec_helper'

# describe IevApi::Client do
#   describe 'initialization' do
#     before do
#       @keys = IevApi::Configuration::VALID_OPTIONS_KEYS
#     end
    
#     context "with module configuration" do
#       before do
#         IevApi.configure do |config|
#           @keys.each do |key|
#             config.send("#{key}=", key)
#           end
#         end
#       end

#       after do
#         IevApi.reset
#       end

#       it "should inherit module configuration" do
#         api = IevApi::Client.new
#         @keys.each do |key|
#           expect(api.send(key)).to eq(key)
#         end
#       end

#       context "with class configuration" do

#         before do
#           @configuration = {
#             :account => 'test',
#             :auth_token => 'token',
#             :secure => true,
#             :connection_options => {},
#             :adapter => :em_http,
#             :user_agent => 'Iev API Tests',
#             :middleware => IevApi::Configuration::DEFAULT_MIDDLEWARE
#           }
#         end

#         context "during initialization" do
#           it "should override module configuration" do
#             api = IevApi::Client.new(@configuration)
#             @keys.each do |key|
#               expect(api.send(key)).to eq(@configuration[key])
#             end
#           end
#         end

#         context "after initilization" do
#           it "should override module configuration after initialization" do
#             api = IevApi::Client.new
#             @configuration.each do |key, value|
#               api.send("#{key}=", value)
#             end
#             @keys.each do |key|
#               expect(api.send(key)).to eq(@configuration[key])
#             end
#           end
#         end
#       end
#     end

#     # context 'with customized middleware' do
#     #   let(:logdev) { StringIO.new }
#     #   # Client#connection is a private method.
#     #   # Adding logger middleware component with an argument it should receive
#     #   # when a connection is initialized
#     #   let(:logger_middleware) { [Faraday::Response::Logger, Logger.new(logdev)] }
#     #   let(:options) do
#     #     {
#     #       :account => 'myapp', :auth_token => 'abcdefg123456', :secure => false,
#     #       :middleware => IevApi::Configuration::DEFAULT_MIDDLEWARE + [logger_middleware]
#     #     }
#     #   end
#     #   let(:api) { IevApi::Client.new(options) }

#     #   # request something to initialize @connection with middleware
#     #   #before { api.jobs("test") }

#     #   it 'splats array to initialize middleware with arguments' do
#     #     # check that the logger added above did receive the argument
#     #     expect(logdev.string).to include(api.projects_path)
#     #   end
#     # end
#   end

#   describe 'api requests'do
#     before(:all) do
#       options = { :account => 'myapp', :secure => false }
#       IevApi.configure(options)

#       @client = IevApi::Client.new
#     end

#   #   it "should fail with errors" do
#   #     expect {
#   #       @client.notices(1696172)
#   #     }.to raise_error(IevApi::AirbrakeError, /You are not authorized to see that page/)
#   #   end

#   #   describe '#deploys' do
#   #     it 'returns an array of deploys' do
#   #       expect(@client.deploys('12345')).to be_kind_of(Array)
#   #     end

#   #     it 'returns deploy data' do
#   #       deploys = @client.deploys('12345')
#   #       first_deploy = deploys.first

#   #       expect(first_deploy.rails_env).to eq('production')
#   #     end

#   #     it 'returns empty when no data' do
#   #       expect(@client.deploys('67890')).to be_kind_of(Array)
#   #     end
#   #   end

#   #   describe '#projects' do
#   #     it 'returns an array of projects' do
#   #       expect(@client.projects).to be_kind_of(Array)
#   #     end

#   #     it 'returns project data' do
#   #       projects = @client.projects
#   #       expect(projects.size).to eq(4)
#   #       expect(projects.first.id).to eq('1')
#   #       expect(projects.first.name).to eq('Venkman')
#   #     end
#   #   end

#   #   describe '#update' do
#   #     it 'should update the status of an error' do
#   #       error = @client.update(1696170, :group => { :resolved => true})
#   #       expect(error.resolved).to be_truthy
#   #     end
#   #   end

#   #   describe '#errors' do
#   #     it "should find a page of the 30 most recent errors" do
#   #       errors = @client.errors
#   #       ordered = errors.sort_by(&:most_recent_notice_at).reverse
#   #       expect(ordered).to eq(errors)
#   #       expect(errors.size).to eq(30)
#   #     end

#   #     it "should paginate errors" do
#   #       errors = @client.errors(:page => 2)
#   #       ordered = errors.sort_by(&:most_recent_notice_at).reverse
#   #       expect(ordered).to eq(errors)
#   #       expect(errors.size).to eq(2)
#   #     end

#   #     it "should use project_id for error path" do
#   #       expect(@client).to receive(:request).with(:get, "/projects/123/groups.xml", {}).and_return(double(:group => 111))
#   #       @client.errors(:project_id => 123)
#   #     end
#   #   end

#   #   describe '#error' do
#   #     it "should find an individual error" do
#   #       error = @client.error(1696170)
#   #       expect(error.action).to eq('index')
#   #       expect(error.id).to eq(1696170)
#   #     end
#   #   end

#   #   describe '#notice' do
#   #     it "finds individual notices" do
#   #       expect(@client.notice(1234, 1696170)).not_to be_nil
#   #     end

#   #     it "finds broken notices" do
#   #       expect(@client.notice(666, 1696170)).not_to be_nil
#   #     end
#   #   end

#   #   describe '#notices' do
#   #     it "finds all error notices" do
#   #       notices = @client.notices(1696170)
#   #       expect(notices.size).to eq(42)
#   #     end

#   #     it "finds error notices for a specific page" do
#   #       notices = @client.notices(1696170, :page => 1)
#   #       expect(notices.size).to eq(30)
#   #       expect(notices.first.backtrace).not_to eq(nil)
#   #       expect(notices.first.id).to eq(1234)
#   #     end

#   #     it "finds all error notices with a page limit" do
#   #       notices = @client.notices(1696171, :pages => 2)
#   #       expect(notices.size).to eq(60)
#   #     end

#   #     it "yields batches" do
#   #       batches = []
#   #       notices = @client.notices(1696171, :pages => 2) do |batch|
#   #         batches << batch
#   #       end
#   #       expect(notices.size).to eq(60)
#   #       expect(batches.map(&:size)).to eq([30,30])
#   #     end

#   #     it "can return raw results" do
#   #       notices = @client.notices(1696170, :raw => true)
#   #       expect(notices.first.backtrace).to eq(nil)
#   #       expect(notices.first.id).to eq(1234)
#   #     end
#   #   end

#   #   describe '#connection' do
#   #     it 'returns a Faraday connection' do
#   #       expect(@client.send(:connection)).to be_kind_of(Faraday::Connection)
#   #     end
#   #   end
#   end

#   # describe '#url_for' do
#   #   before(:all) do
#   #     options = { :account => 'myapp', :auth_token => 'abcdefg123456', :secure => false }
#   #     IevApi.configure(options)

#   #     @client = IevApi::Client.new
#   #   end

#   #   it 'generates web urls for projects' do
#   #     expect(@client.url_for(:projects)).to eq('http://myapp.airbrake.io/projects')
#   #   end

#   #   it 'generates web urls for deploys' do
#   #     expect(@client.url_for(:deploys, '2000')).to eq('http://myapp.airbrake.io/projects/2000/deploys')
#   #   end

#   #   it 'generates web urls for errors' do
#   #     expect(@client.url_for(:errors)).to eq('http://myapp.airbrake.io/groups')
#   #   end

#   #   it 'generates web urls for errors with project_id' do
#   #     expect(@client.url_for(:errors, :project_id => 123)).to eq('http://myapp.airbrake.io/projects/123/groups')
#   #   end

#   #   it 'generates web urls for individual errors' do
#   #     expect(@client.url_for(:error, 1696171)).to eq('http://myapp.airbrake.io/errors/1696171')
#   #   end

#   #   it 'generates web urls for notices' do
#   #     expect(@client.url_for(:notices, 1696171)).to eq('http://myapp.airbrake.io/groups/1696171/notices')
#   #   end

#   #   it 'generates web urls for individual notices' do
#   #     expect(@client.url_for(:notice, 123, 1696171)).to eq('http://myapp.airbrake.io/groups/1696171/notices/123')
#   #   end

#   #   it 'raises an exception when passed an unknown endpoint' do
#   #     expect { @client.url_for(:foo) }.to raise_error(ArgumentError)
#   #   end
#   # end
# end
