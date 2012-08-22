class String
  def javascript_camelize
    self.gsub(/_([a-zA-Z])/) {$1.capitalize}
  end
end

class Symbol
  def javascript_camelize
    self.to_s.javascript_camelize
  end
end