xml.instruct! :xml, :version => "1.0"  
xml.rss :version => "2.0" do  
  xml.channel do
    xml.title "SoundCloud favorites RSS"
    xml.description "Top favorited artists + bio"

    @favorites_top_list.each do |favorite|
      xml.item do
        xml.title favorite[0]
        xml.link "http://soundcloud.com/#{favorite[0]}"
        xml.description "#{favorite[0]} has been liked #{favorite[1]} time(s)"
      end
    end
  end  
end  
