function split(str, sep)
  local parts = {}
  for part in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(parts, part)
  end
  return parts
end

function vec_m_scalar(vec, scalar)
  local t = {}
  for i=1,#vec do 
    t[i] = vec[i] * scalar
  end 
  return t 
end 