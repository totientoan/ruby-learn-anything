class VideosController < ApplicationController
    VIDEO_FILE_MAP = {
        'tomjerry' => 'public/videos/tomandjerry.mp4',
        'tom' => 'public/videos/Tom.mp4',
        'ruby' => 'public/videos/ruby_demo.mp4'
      }.freeze

    def index
        
    end
  
    def create

    end

    def store
        
    end

    def show
        file_name = params[:file_name]
        file_path = VIDEO_FILE_MAP[file_name]
    
        unless file_path
          return render plain: 'File not found', status: 404
        end
    
        file_size = File.size(file_path)
    
        # Ensure there is a range given for the video
        range = request.headers['Range']
        if range
          parts = range.gsub(/bytes=/, '').split('-')
          start_range = parts[0].to_i
          end_range = parts[1] ? parts[1].to_i : file_size - 1
    
          chunk_size = 1_000_000
    
          response.headers['Content-Range'] = "bytes #{start_range}-#{end_range}/#{file_size}"
          response.headers['Accept-Ranges'] = 'bytes'
          response.headers['Content-Length'] = chunk_size.to_s
          response.headers['Content-Type'] = 'video/mp4'
    
          response.status = 206
    
          File.open(file_path, 'rb') do |file|
            file.seek(start_range)
            data = file.read(chunk_size)
            response.stream.write(data)
          end
        else
          response.headers['Content-Length'] = file_size.to_s
          response.headers['Content-Type'] = 'video/mp4'
    
          response.status = 200
    
          File.open(file_path, 'rb') do |file|
            response.stream.write(file.read)
          end
        end
    ensure
        response.stream.close
    end

    def edit

    end
    
    def update 
        
    end

    def destroy
        
    end
  end