local solutions = {
    possibleSolutions = {
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15},
        {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0}
    }
}

function solutions.isSolution(array)
    for i=1, #solutions.possibleSolutions do
        if (#array == #solutions.possibleSolutions[i]) then
            local notEquals = false
            for j=1, #array do
                if (array[j] ~= solutions.possibleSolutions[i][j]) then
                    notEquals = true
                    break
                end
            end
            if (not notEquals) then
                return true
            end
        end
    end
    return false
end

return solutions
