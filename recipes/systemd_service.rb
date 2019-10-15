# Our systemd service uses the "simple" service type, so we need
# stunnel not to fork, and consequently have no need for a pid file.
node.override['stunnel']['foreground'] = true
node.override['stunnel']['pid'] = ''

systemd_unit 'nodebb.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=stunnel TLS proxy
  After=network.target

  [Service]
  Type=simple
  ExecStart=/usr/bin/stunnel

  [Install]
  WantedBy=multi-user.target
  EOU

  action [:create, :enable, :start]
end
