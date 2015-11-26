module GenerateScript
  def generate_script(source, path, name, port)
    vars = {
      name: name,
      port: port,
      homedir: "/usr/share/mezuro/#{name}",
      configdir: "/etc/mezuro/#{name}",
      username: name.gsub('-', '_')
    }

    content = File.read(source)
    vars.each do |key, value|
      content.gsub!(/^#{key}=.*$/, "#{key}='#{value}'")
    end

    File.open(path, 'w', 0755) do |dest_file|
      dest_file.write content
    end
  end
end
