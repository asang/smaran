module UserSessionsHelper
  def is_local_client
    request.remote_ip == '127.0.0.1' or
        request.remote_ip == '0.0.0.0' or
        request.remote_ip =~ /^fe80:+/ or
        request.remote_ip == '::1' or
        request.remote_ip =~ /^192.168.+/
  end
end
