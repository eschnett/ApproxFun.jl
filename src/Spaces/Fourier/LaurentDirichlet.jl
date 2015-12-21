export LaurentDirichlet

##
# LaurentDirichlet represents functions in the basis
#       1, z^(-1)+1,z+1,z^(-2)+z^(-1),z^2+z,…
# which incorporates decay at z = -1
# TODO: restructure as SumSpace made out of HardyDirichlet
##



immutable LaurentDirichlet{DD} <: UnivariateSpace{ComplexBasis,DD}
    domain::DD
    LaurentDirichlet(d::DD)=new(d)
end
LaurentDirichlet{T<:Number}(d::Vector{T})=LaurentDirichlet(PeriodicDomain(d))
LaurentDirichlet(d::Domain)=LaurentDirichlet{typeof(d)}(d)
LaurentDirichlet()=LaurentDirichlet(PeriodicInterval())

spacescompatible(a::LaurentDirichlet,b::LaurentDirichlet)=domainscompatible(a,b)

canonicalspace(S::LaurentDirichlet)=Laurent(domain(S))

bandinds{DD}(::ConcreteConversion{LaurentDirichlet{DD},Laurent{DD}})=0,2
function addentries!{DD}(C::ConcreteConversion{LaurentDirichlet{DD},Laurent{DD}},A,kr::Range,::Colon)
    if 1 in kr
        A[1,2]+=1
    end
    toeplitz_addentries!([],[1.,0.,1.],A,kr)
end


conversion_rule{DD}(b::LaurentDirichlet,a::Laurent{DD})=b

Base.real{DD}(f::Fun{LaurentDirichlet{DD}}) = real(Fun(f,Laurent(domain(f))))
Base.imag{DD}(f::Fun{LaurentDirichlet{DD}}) = imag(Fun(f,Laurent(domain(f))))

##
# CosDirichlet represents
# 1,cos(θ)+1,cos(2θ)+cos(θ),…
#


immutable CosDirichlet{DD} <: RealUnivariateSpace{DD}
    domain::DD
end

CosDirichlet()=CosDirichlet(PeriodicInterval())

spacescompatible(a::CosDirichlet,b::CosDirichlet)=domainscompatible(a,b)

canonicalspace(S::CosDirichlet)=CosSpace(domain(S))

bandinds{CS<:CosSpace,CD<:CosDirichlet}(::ConcreteConversion{CD,CS})=0,1
addentries!{CS<:CosSpace,CD<:CosDirichlet}(C::ConcreteConversion{CD,CS},A,kr::Range,::Colon)=toeplitz_addentries!([],[1.,1.],A,kr)


conversion_rule(b::CosDirichlet,a::CosSpace)=b
