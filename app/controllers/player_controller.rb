class PlayerController < ApplicationController
  def index
    Net::SSH.start('remote', 'username', :password => "password") do |ssh|
      ssh.forward.remote_to(3689, 'localhost', 3689)
      ssh.loop  
      @daap = Net::DAAP::Client.new('localhost')
    end  
    get_song
  end

  private

  def get_song
    @filepath = "public/user/tomeara/streamed.mp3"
    @publicpath = "/user/tomeara/streamed.mp3"
    # Calling connect with a block will automatically disconnect for us
      @daap.connect do |dsn|
        @daap.databases.each do |db|
          # Here is a stream example:
          File.open(@filepath, "w") do |f|
            db.songs[4].get { |str| f.write str }
          end
        end
      end
  end
  
  def get_artists
    # Calling connect with a block will automatically disconnect for us
      @daap.connect do |dsn|
        @daap.databases.each do |db|
          db.artists.each do |artist|
            @artists = artist.songs.each { |song| puts song.name }
            artist.albums.each do |album|
              @song = album.songs.each { |song| puts song.name }
            end
          end
        end
      end
  end
  
end
