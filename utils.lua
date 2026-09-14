function split(str, sep)
  local parts = {}
  for part in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(parts, part)
  end
  return parts
end

-- rudimentary numpy lol 
function vec_m_scalar(vec, scalar)
  local t = {}
  for i=1,#vec do 
    t[i] = vec[i] * scalar
  end 
  return t 
end 

function vec_cat(vec1, vec2)
  local out = {}
  for i=1,#vec1 do out[#out+1] = vec1[i] end  
  for i=1,#vec2 do out[#out+1] = vec2[i] end  
  return out 
end  