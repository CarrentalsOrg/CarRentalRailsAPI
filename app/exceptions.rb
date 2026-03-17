module Exceptions
  class PermissionDenied < StandardError
    def initialize(message = nil)
      super(message)
    end
  end
end
