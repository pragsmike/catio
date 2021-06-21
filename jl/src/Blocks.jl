
abstract type Block end


function getInputBuffer(block::Block)
    return Nothing
end
function getOutputBuffer(block::Block)
    return Nothing
end
function progressString(block::Block)
    return Nothing
end

function dofile(block::Block, infn, outfn)
    open(infn) do instream
        open(outfn, "w") do outstream
            for i in 1:6000000
                try
                    read!(instream, getInputBuffer(block))
                catch
                    @printf("Input ended after reading %i frames\n", i)
                    break
                end
                tick(block)
                if i % 25000 == 0
                    println(progressString(block))
                end
                write(outstream, getOutputBuffer(block))
            end
        end
    end
end
