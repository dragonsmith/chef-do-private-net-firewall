
consul_service_name = if os[:name] == 'ubuntu' and os[:release].to_i < 16
                        'consul'
                      else
                        'consul.service'
                      end

describe service(consul_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port('192.168.33.33', 8301) do
  it { should be_listening }
end

describe port(8302) do
  it { should be_listening }
end

describe port('192.168.33.33', 8500) do
  it { should be_listening }
end

describe port('127.0.0.1', 8600) do
  it { should be_listening }
end

# HACK: Consul-template does not manage to render its template in time.
sleep 15

describe command('ufw status') do
  its('stdout') { should match(/Status:\sactive/) }

  # Internal services
  [8300, 8500].each do |port|
    its('stdout') { should match(/^#{port}\son\seth1.*192\.168\.33\.33/) }
  end

  # External services
  its('stdout') { should match(/^80\s+ALLOW\s+Anywhere/) }
end
