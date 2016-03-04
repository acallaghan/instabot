require 'socket'
require 'escper'
require 'mini_magick'

Socket.tcp_server_loop(12000) {|sock, client_addrinfo|
  begin
    file = File.new("./#{Time.now.to_i}.jpg", "w+")
    io = IO.copy_stream(sock, file)
  ensure
    sock.close
  end

  path = File.path(file)

  image = MiniMagick::Image.open(path)
  image.combine_options do |b|
    b.resize "250x200>"
    b.rotate "-90"
  end
  image.format "png"
  image.write("output.png")

  File.open('/dev/usb/lp0','w') { |f| f.write(Escper::Img.new("./output.png", :file).to_s) }
  

} 
