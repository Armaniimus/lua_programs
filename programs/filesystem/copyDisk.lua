for _, filename in ipairs(fs.list("disk")) do
  fs.copy("disk/"..filename,"disk2/"..filename)
end
