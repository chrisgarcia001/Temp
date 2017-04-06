module Util
  
  # -------------------------------------------------------------------------------------------------------------
  # File Utils
  
  # Write the string data to the specified file.
  def write data, filename
    File.open(filename, 'w') do |f|  
      f.puts data
    end  
  end
  
  # Read raw contents
  def read(filename) 
    data = ''
    File.open(filename, "r") do |infile|      
      while (line = infile.gets)
        data << line
      end
    end
    data
  end
  
  # Read lines from a file
  def read_lines(filename) 
    data = []
    File.open(filename, "r") do |infile|      
      while (line = infile.gets)
        clean = line.strip
        data << clean if !clean.empty?
      end
    end
    data
  end
  
  # Cast a value to its proper type
  def cast val
    return val if val.include?('/') or val.include?('\\')
    begin
      return eval(val)
    rescue 
      'Cast Exception Handled'
    end
    val
  end
  
  # Reads params from a file. Can handle cases where some params contain an array of values. All
  # params that have only a single value will not be arrays.
  def read_params csv_file, sym_keys = true, autocast=true
    params = {}
    File.open(csv_file, "r") do |infile|
      while (line = infile.gets)
        if !['#', nil, ''].member? line.strip.split('')[0]
          par = line.delete("\n").split(',')
          key = par[0].downcase.split(' ').join('_')
          key = key.to_sym if sym_keys
          val = par[1..par.length]
          val = val.map{|v| cast(v)} if autocast
          val = val[0] if val.select{|x| x != nil}.length < 2
          params[key] = val
        end
      end
    end
    params
  end
  
  # Create a generic CSV file. Data is an array[][], with the first
  # array being column headers and the next being the rows with
  # data elements in corrsponding column header positions.
  def to_generic_csv data, filename
    s = ''
    0.upto(data.length - 1) {|i| s += data[i].map{|val| val.to_s}.join(',') + "\n"}
    File.open(filename, 'w') do |f|  
      f.puts s
    end  
  end
  
  # Converts a list of hashes having same form to a CSV file. Optionally takes a subset of keys in each hash as the columns.
  def hashlist_to_csv hashlist, filename, columns=nil
    colnames = []
    colnames = hashlist[0].keys if !hashlist.empty?
    colnames = columns if columns
    data = [colnames.map{|x| x.to_s}]
    hashlist.each{|h| v = []; colnames.each{|c| v << h[c]}; data << v}
    to_generic_csv data, filename
  end
  
  # Pad a string with leading 0's
  def str_digitize(i, digits)
    s = i.to_s
    while s.length < digits
      s = '0' + s
    end
    s
  end
  
end