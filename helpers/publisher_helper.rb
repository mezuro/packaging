module Helpers
  module PublisherHelper
    def publish_package(type, package)
      puts ">> Starting to publish #{package} package on BinTray"
      underscored_package = package.gsub('-', '_')
      data = Kernel.const_get("MezuroInformations::#{underscored_package.upcase}")[:data]
      info = Kernel.const_get("MezuroInformations::#{underscored_package.upcase}")[:info]
      version = "#{info[:version]}-#{info[:release]}"
      path = send("#{type}_path", package, info)

      puts ">> Creating package"
      PackageManager.create(type, data)

      puts ">> Creating version #{version}"
      VersionManager.create(type, package, { name: version, desc: data[:description] })

      puts ">> Uploading package on #{path}"
      if type == 'deb'
        ContentManager.debian_upload(type, package, version, "#{package}-#{version}_all.deb",
        {distros: 'jessie', components: 'main', archs: 'all'}, path)
      else
        ContentManager.upload(type, package, version, "#{package}-#{version}.noarch.rpm", path)
      end
    end
  end
end
