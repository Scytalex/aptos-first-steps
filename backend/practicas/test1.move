module account::test1 {
  use std::debug::print;

  fun scenario_1(){
    let value_a = 10;
    let imm_ref: &u64 = &value_a;
    print(imm_ref);
  }

#[test]
  fun test_function(){
    scenario_!();
  }
}
