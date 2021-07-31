class Chouette::Hub::TimeTableExporter
  include ERB::Util
  attr_accessor :directory, :template, :time_table, :code, :comment, :start_date, :end_date, :calendar, :identifier
  
  def initialize(time_table, directory, index)
    @time_table = time_table
    @directory = directory
    @template = File.open('app/views/api/hub/periodes.hub.erb' ){ |f| f.read }
    
    @code = time_table.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
    @comment = time_table.comment.encode(Encoding::Windows_1252) if time_table.comment
    @start_date = time_table.start_date.strftime("%d/%m/%Y")
    @end_date = time_table.end_date.strftime("%d/%m/%Y")
    @calendar = ""
    s_date = time_table.start_date
    e_date = time_table.end_date
    while s_date <= e_date
      if time_table.include_day?(s_date)
        @calendar += "1"
      else
        @calendar += "0"
      end
      s_date = s_date.next_day
    end
    @identifier = index
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/PERIODE.TXT"
  end
  
  def self.save(time_tables, directory, hub_export)
    index = 1
    time_tables.each do |time_table|
      self.new(time_table, directory, index).tap do |specific_exporter|
        specific_exporter.save
        index += 1
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|TIME_TABLE_COUNT", :arguments => {"0" => time_tables.size})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("PERIODE\u000D\u000A") if f.size == 0
      f.write(render)
    end if time_table.present?
  end
end

