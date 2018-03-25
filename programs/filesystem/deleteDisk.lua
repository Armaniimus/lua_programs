for _, filename in ipairs(fs.list("disk2")) do
  fs.delete("disk2/"..filename)
end
