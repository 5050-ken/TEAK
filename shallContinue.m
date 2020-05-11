function result = shallContinue(active)

count = 0;
for i = 1:length(active.Elements)
    if active.Elements(i).ID ~= -1
       count = count + 1;
    end
end

result = count > 1;

end
