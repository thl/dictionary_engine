module StaticPages 
  
  def self.build
    puts 'building static pages'
    
    # debugger
    ComplexScripts::TibetanLetter.all.each do |letter|
      total = Definition.where(:root_letter_id => letter.id, :level => 'head term').count
      puts total 
      count = 0
      @terms = []
      puts "page_#{letter.id}.rhtml"
      file = File.open(Rails.root.join("tmp/page_#{letter.id}.rhtml"), 'w')
      while count < total
        #d = Definition.find(:first, :conditions => {:root_letter_id => letter.id, :level => 'head term'}, :order => 'sort_order asc', :offset => count)
        d = Definition.where(:root_letter_id => letter.id, :level => 'head term').order('sort_order asc').offset(count).first
        
        str = "<p>#{d.term}</p>"
        
        js = "$('#list_#{count}').show();jQuery.ajax({	success: function(request) {jQuery('#group_#{count}').html(request);tb_init('a.thickbox, area.thickbox, input.thickbox');$('#p_#{d.id}').hide();$('#plus_term_#{d.id}');$('#minus_term_#{d.id}').show();$('#list_#{count}').show();} ,type:'get' ,url:'/definitions/alphabet_sub_list?letter=#{letter.id}&offset=#{count}' }); return false;"
        
        #str = "<span style=\"display:none\" id=\"plus_term_#{d.id}\"><a onclick=\"$('#plus_term_#{d.id}').hide();$('#minus_term_#{d.id}').show();$('#list_#{count}').show();return false;\" href=\"#\"><img src=\"/images/btn-plus-sm.gif\" border=0></a></span><span style=\"display:none\" id=\"minus_term_#{d.id}\"><a onclick=\"$('#plus_term_#{d.id}').show();$('#minus_term_#{d.id}').hide();$('#list_#{count}').hide();return false;\" href=\"#\"><img src=\"/images/btn-minus-sm.gif\" border=0></a></span> <a id=\"p_#{d.id}\" onclick=\"#{js}\" href=\"#\"><img src=\"/images/btn-plus-sm.gif\"></a> <span class=\"bo\">#{d.term}</span> #{d.wylie} #{d.phonetic}<br><div id=\"list_#{count}\" style=\"display:none\"><dl><dd><div id=\"group_#{count}\"><img src=\"/images/loadingAnimation2.gif\"></div>
      	str = "<span style=\"display:none\"  id=\"plus_term_#{d.id}\"><a onclick=\"$('#plus_term_#{d.id}').hide();$('#minus_term_#{d.id}').show();$('#list_#{count}').show();return false;\" href=\"#\"><img src=\"/images/btn-plus-sm.gif\" border=0></a></span><span style=\"display:none\" id=\"minus_term_#{d.id}\"><a onclick=\"$('#plus_term_#{d.id}').show();$('#minus_term_#{d.id}').hide();$('#list_#{count}').hide();return false;\" href=\"#\"><img src=\"/images/btn-minus-sm.gif\" border=0></a></span> <a id=\"p_#{d.id}\" onclick=\"#{js}\" href=\"#\"><img src=\"/images/btn-plus-sm.gif\"></a> <span class=\"bo\">#{d.term}</span> #{d.wylie} #{d.phonetic}<br><div id=\"list_#{count}\" style=\"display:none\"><dl><dd><div id=\"group_#{count}\"><img src=\"/images/loadingAnimation2.gif\"></div>
      		</dd>
      	</dl>
      	</div>"
        
        file.puts str
        count += 100
      end
      file.flush
      file.close
    end
    
  end
end
