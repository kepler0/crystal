require "../abi"

# Based on https://github.com/rust-lang/rust/blob/master/src/librustc_trans/trans/cabi_arm.rs
class LLVM::ABI::ARM < LLVM::ABI
  #Woot, Apple diversification.
  enum Flavor
    General
    IOS
  end

  def abi_info(atys: Array(Type), rty: Type, ret_def: Bool, flav: Flavor)
    align_fn = case flav
    when Flavor::General then general_align(rty)
    when Flavor::IOS then ios_align(rty)
    end
  end

  ##
  # iOS related functions
  ##

  # For more information see:
  # ARMv7
  # https://developer.apple.com/library/ios/documentation/Xcode/Conceptual
  #    /iPhoneOSABIReference/Articles/ARMv7FunctionCallingConventions.html
  # ARMv6
  # https://developer.apple.com/library/ios/documentation/Xcode/Conceptual
  #    /iPhoneOSABIReference/Articles/ARMv6FunctionCallingConventions.html
  private def ios_align(type: Type)
    case type.kind
    when Type::Kind::Integer then [4, (((type.int_width) + 7) / 8)].min
    when Type::Kind::Pointer then 4
    when Type::Kind::Float then 4
    when Type::Kind::Double then 4
    when Type::Kind::Struct
    when Type::Kind::Array then ios_align(type.element_type)
    when Type::Kind::Vector then ios_align(type.element_type) * type.vector_length
    else
      raise "Unhandled Type::Kind: #{ty.kind}"
    end
  end

  ##
  # General ARM related functions
  ##

  private def general_align(type: Type)
    case type.kind
    when Type::Kind::Integer then ((type.int_width) + 7) / 8
    when Type::Kind::Pointer then 4
    when Type::Kind::Float then 4
    when Type::Kind::Double then 8
    when Type::Kind::Struct
    when Type::Kind::Array then general_align(type.element_type)
    when Type::Kind::Vector then general_align(type.element_type) * type.vector_length
    else
      raise "Unhandled Type::Kind: #{ty.kind}"
    end
  end

  ##
  # ARM functions
  ##

  private def reg_type?(type: Type)
    case type.kind
    when Type::Kind::Integer then true
    when Type::Kind::Pointer then true
    when Type::Kind::Float then true
    when Type::Kind::Double then true
    when Type::Kind::Vector then true
    else then false
    end
  end

  private def align_up_to(off, a)
    (off + a - 1) / a * a
  end

  private def align(off, ty: Type, align_fn)
    align_up_to(off, align_fn(ty))
  end
end
