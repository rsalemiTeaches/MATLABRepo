data = labData()
ideal = [1.22;2.45;3.67;4.90];
perError = (data - ideal) ./ ideal .* 100
