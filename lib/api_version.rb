# Контроллер, определяющий версию API
class ApiVersion
  def initialize(version)
    @version = version
  end

  def matches?(request)
    versioned_accept_header?(request) || version_one?(request)
  end

  protected

    def versioned_accept_header?(request)
      accept = request.headers['Accept']

      accept && accept[/application\/vnd\.organization-v#{@version}\+json/]
    end

    def unversioned_accept_header?(request)
      accept = request.headers['Accept']

      accept.blank? || accept[/application\/vnd\.organization/].nil?
    end

    def version_one?(request)
      (@version == 1 || @version == 2) && unversioned_accept_header?(request)
    end
end
