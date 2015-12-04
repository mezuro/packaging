module Helpers
  module PathHelper
    def deb_path(pkg, info)
      "pkgs/#{pkg}/#{pkg}_#{info[:version]}-#{info[:release]}_all.deb"
    end

    def rpm_path(pkg, info)
      "pkgs/#{pkg}/#{pkg}-#{info[:version]}-#{info[:release]}.noarch.rpm"
    end
  end
end