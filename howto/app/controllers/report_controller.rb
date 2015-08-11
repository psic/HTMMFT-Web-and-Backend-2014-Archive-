class ReportController < ApplicationController
  def index
  directory = "public/report"
  path = File.join(directory, "bug.html")
  @bug = ''
  f = File.open(path, "r") 
  f.each_line do |line|
    @bug += line
  end
   f.close
  path = File.join(directory, "func.html")
  @func = ''
  f = File.open(path, "r") 
  f.each_line do |line1|
    @func += line1
  end
   f.close
   path = File.join(directory, "LO.html")
  @lo = ''
  f = File.open(path, "r") 
  f.each_line do |line2|
    @lo += line2
  end
   f.close      
 end
   
   def post_func
    directory = "public/report"
    path = File.join(directory, "func.html")
	 @func=''
	File.open(path, "r+") do |f|	
		f.each_line do |line|
		@func += line
		end	
		f.seek(0)
		f.write("<BR>*"+ "_"*12 + Time.now.strftime('%b %d,%Y ( %H:%M )') +"_"*12+ "*<BR>"+ params[:func] +"\n")
		f.write(@func)
		f.close
	end
	redirect_to :controller=>"report",:action=>"index"
   end
   
   def post_LO
    directory = "public/report"
    path = File.join(directory, "LO.html")
	 @LO=''
	File.open(path, "r+") do |f|	
		f.each_line do |line|
		@LO += line
		end	
		f.seek(0)
		f.write("<BR>*"+ "_"*12 + Time.now.strftime('%b %d,%Y ( %H:%M )') +"_"*12+ "*<BR>"+ params[:lo] +"\n")
		f.write(@LO)
		f.close
	end
	redirect_to :controller=>"report",:action=>"index"
   end
   
   def post_bug
   directory = "public/report"
    path = File.join(directory, "bug.html")
    @bug=''
	File.open(path, "r+") do |f|	
		f.each_line do |line|
		@bug += line
		end	
		f.seek(0)
		f.write("<BR>*"+ "_"*12 + Time.now.strftime('%b %d,%Y ( %H:%M )') +"_"*12+ "*<BR>"+ params[:bug] +"\n")
		f.write(@bug)
		f.close
	end
	redirect_to :controller=>"report",:action=>"index"
   end
end
