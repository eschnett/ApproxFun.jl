## Functions that depend on the structure of BandedMatrix


function pad!(A::BandedMatrix,n,m)
    A.data=pad(A.data,size(A.data,1),m)
    A.m=n
    A
end



# linear algebra


## Constructors that involve MultivariateFun

Fun(f::Function) = Fun(F(f))

function Fun(f::F)
    if hasnumargs(f.f,1)
        # check for tuple
        try
            f(0)
        catch ex
            if isa(ex,BoundsError)
                # assume its a tuple
                return Fun(f,Interval()^2)
            else
                throw(ex)
            end
        end

        Fun(f,Interval())
    elseif hasnumargs(f.f,2)
            Fun(f,Interval()^2)
    else
        error("Function not defined on interval or square")
    end
end




## These hacks support PDEs with block matrices



## dot for vector{Number} * Vector{Fun}

function Base.dot{T<:Union{Number,Fun,MultivariateFun},F<:Union{Fun,MultivariateFun}}(c::Vector{T},f::Vector{F})
    @assert length(c)==length(f)
    ret = conj(first(c))*first(f)
    for k = 2:length(c)
        ret += conj(c[k])*f[k]
    end
    ret
end


function dotu{T<:Union{Fun,MultivariateFun,Number},F<:Union{Fun,MultivariateFun,Number}}(c::Vector{T},f::Vector{F})
    @assert length(c)==length(f)
    ret = zero(Base.promote_op(*,T,F))
    for k = 1:length(c)
        ret += c[k]*f[k]
    end
    ret
end



## Gets blockbandinds working for SpectralMeasures

# TODO: Is this a good definition?
blockbandinds{AT,TT,SS1<:Union{EuclideanSpace,SequenceSpace},
              SS2<:Union{EuclideanSpace,SequenceSpace}}(T::FiniteOperator{AT,TT,SS1,SS2}) = bandinds(T)
