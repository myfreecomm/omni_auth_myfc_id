# Marretado para poder passar em todas as requisições o parâmetro :scope que está chegando aqui em forma do :form_data
module OAuth
  class Consumer

    # create the http request object for a given http_method and path
    def create_http_request(http_method, path, *arguments)
      http_method = http_method.to_sym

      if [:post, :put].include?(http_method)
        data = arguments.shift
      end

      headers = arguments.first.is_a?(Hash) ? arguments.shift : {}

      case http_method
      when :post
        request = Net::HTTP::Post.new(path,headers)
        request["Content-Length"] = '0' # Default to 0
      when :put
        request = Net::HTTP::Put.new(path,headers)
        request["Content-Length"] = '0' # Default to 0
      when :get
        request = Net::HTTP::Get.new(path,headers)
      when :delete
        request =  Net::HTTP::Delete.new(path,headers)
      when :head
        request = Net::HTTP::Head.new(path,headers)
      else
        raise ArgumentError, "Don't know how to handle http_method: :#{http_method.to_s}"
      end
      
      # Alterado por Rafael Lima em 25/11/2010
      if data.nil?
        request.set_form_data(options[:form_data])
      elsif data.is_a?(Hash)
        form_data = options[:form_data] || {}
        data.each {|k,v| form_data[k.to_s] = v if !v.nil?}
        request.set_form_data(form_data)
      elsif data
        if data.respond_to?(:read)
          request.body_stream = data
          if data.respond_to?(:length)
            request["Content-Length"] = data.length.to_s
          elsif data.respond_to?(:stat) && data.stat.respond_to?(:size)
            request["Content-Length"] = data.stat.size.to_s
          else
            raise ArgumentError, "Don't know how to send a body_stream that doesn't respond to .length or .stat.size"
          end
        else
          request.body = data.to_s
          request["Content-Length"] = request.body.length.to_s
        end
      end

      request
    end

  end
end