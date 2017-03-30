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
  
  # Reads in params from a CSV file with <name, value>
  # param format per line
  def read_params csv_file, sym_keys = true
    params = {}
    File.open(csv_file, "r") do |infile|
      while (line = infile.gets)
        par = line.delete("\n").split(',')
        key = par[0].downcase.split(' ').join('_')
        key = key.to_sym if sym_keys
        val = par[1]
        params[key] = val
      end
    end
    params
  end
  
  # Reads params where some contain an array of values. All
  # params that have only a single value will not be arrays.
  def read_multivalue_params csv_file, sym_keys = true
    params = {}
    File.open(csv_file, "r") do |infile|
      while (line = infile.gets)
        par = line.delete("\n").split(',')
        key = par[0].downcase.split(' ').join('_')
        key = key.to_sym if sym_keys
        val = par[1..par.length]
        val = par[1] if val.select{|x| x != nil}.length < 2
        params[key] = val
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
  
  # Pad a string with leading 0's
  def str_digitize(i, digits)
    s = i.to_s
    while s.length < digits
      s = '0' + s
    end
    s
  end
  
end