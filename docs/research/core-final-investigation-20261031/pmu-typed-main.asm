
/tmp/core-final-pmu-binaries-20261101/exec02:     file format elf64-x86-64


Disassembly of section .text:

0000000000181e00 <allocation_pmu_probe::main>:
  181e00:	55                   	push   %rbp
  181e01:	41 57                	push   %r15
  181e03:	41 56                	push   %r14
  181e05:	41 55                	push   %r13
  181e07:	41 54                	push   %r12
  181e09:	53                   	push   %rbx
  181e0a:	48 81 ec 18 0e 00 00 	sub    $0xe18,%rsp
  181e11:	48 8d 9c 24 78 02 00 	lea    0x278(%rsp),%rbx
  181e18:	00 
  181e19:	48 89 df             	mov    %rbx,%rdi
  181e1c:	ff 15 86 d0 4b 00    	call   *0x4bd086(%rip)        # 63eea8 <_DYNAMIC+0x818>
  181e22:	48 c7 84 24 98 02 00 	movq   $0x1,0x298(%rsp)
  181e29:	00 01 00 00 00 
  181e2e:	48 8d bc 24 f8 00 00 	lea    0xf8(%rsp),%rdi
  181e35:	00 
  181e36:	48 89 de             	mov    %rbx,%rsi
  181e39:	e8 72 89 fe ff       	call   16a7b0 <<alloc::vec::Vec<alloc::string::String> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<alloc::string::String, core::iter::adapters::skip::Skip<std::env::Args>>>::from_iter>
  181e3e:	4c 8b a4 24 08 01 00 	mov    0x108(%rsp),%r12
  181e45:	00 
  181e46:	4c 89 a4 24 78 02 00 	mov    %r12,0x278(%rsp)
  181e4d:	00 
  181e4e:	49 83 fc 07          	cmp    $0x7,%r12
  181e52:	0f 85 6e 17 00 00    	jne    1835c6 <allocation_pmu_probe::main+0x17c6>
  181e58:	4c 8b bc 24 00 01 00 	mov    0x100(%rsp),%r15
  181e5f:	00 
  181e60:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  181e64:	49 8b 77 10          	mov    0x10(%r15),%rsi
  181e68:	48 83 fe 01          	cmp    $0x1,%rsi
  181e6c:	74 0e                	je     181e7c <allocation_pmu_probe::main+0x7c>
  181e6e:	48 85 f6             	test   %rsi,%rsi
  181e71:	0f 84 1a 1c 00 00    	je     183a91 <allocation_pmu_probe::main+0x1c91>
  181e77:	0f b6 11             	movzbl (%rcx),%edx
  181e7a:	eb 17                	jmp    181e93 <allocation_pmu_probe::main+0x93>
  181e7c:	0f b6 11             	movzbl (%rcx),%edx
  181e7f:	b0 01                	mov    $0x1,%al
  181e81:	83 fa 2b             	cmp    $0x2b,%edx
  181e84:	0f 84 a4 16 00 00    	je     18352e <allocation_pmu_probe::main+0x172e>
  181e8a:	83 fa 2d             	cmp    $0x2d,%edx
  181e8d:	0f 84 9b 16 00 00    	je     18352e <allocation_pmu_probe::main+0x172e>
  181e93:	31 c0                	xor    %eax,%eax
  181e95:	80 fa 2b             	cmp    $0x2b,%dl
  181e98:	0f 94 c0             	sete   %al
  181e9b:	48 89 f2             	mov    %rsi,%rdx
  181e9e:	48 29 c2             	sub    %rax,%rdx
  181ea1:	48 01 c1             	add    %rax,%rcx
  181ea4:	48 f7 d8             	neg    %rax
  181ea7:	48 83 fa 11          	cmp    $0x11,%rdx
  181eab:	73 3a                	jae    181ee7 <allocation_pmu_probe::main+0xe7>
  181ead:	48 85 d2             	test   %rdx,%rdx
  181eb0:	0f 84 7d 00 00 00    	je     181f33 <allocation_pmu_probe::main+0x133>
  181eb6:	48 01 c6             	add    %rax,%rsi
  181eb9:	48 f7 de             	neg    %rsi
  181ebc:	31 c0                	xor    %eax,%eax
  181ebe:	31 d2                	xor    %edx,%edx
  181ec0:	0f b6 3c 11          	movzbl (%rcx,%rdx,1),%edi
  181ec4:	83 c7 d0             	add    $0xffffffd0,%edi
  181ec7:	83 ff 09             	cmp    $0x9,%edi
  181eca:	0f 87 30 1b 00 00    	ja     183a00 <allocation_pmu_probe::main+0x1c00>
  181ed0:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  181ed4:	89 ff                	mov    %edi,%edi
  181ed6:	48 8d 04 47          	lea    (%rdi,%rax,2),%rax
  181eda:	48 ff c2             	inc    %rdx
  181edd:	48 89 f7             	mov    %rsi,%rdi
  181ee0:	48 01 d7             	add    %rdx,%rdi
  181ee3:	75 db                	jne    181ec0 <allocation_pmu_probe::main+0xc0>
  181ee5:	eb 4e                	jmp    181f35 <allocation_pmu_probe::main+0x135>
  181ee7:	48 01 c6             	add    %rax,%rsi
  181eea:	48 f7 de             	neg    %rsi
  181eed:	31 c0                	xor    %eax,%eax
  181eef:	bf 0a 00 00 00       	mov    $0xa,%edi
  181ef4:	45 31 c0             	xor    %r8d,%r8d
  181ef7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  181efe:	00 00 
  181f00:	48 89 f2             	mov    %rsi,%rdx
  181f03:	4c 01 c2             	add    %r8,%rdx
  181f06:	74 2d                	je     181f35 <allocation_pmu_probe::main+0x135>
  181f08:	48 f7 e7             	mul    %rdi
  181f0b:	42 0f b6 14 01       	movzbl (%rcx,%r8,1),%edx
  181f10:	0f 80 0e 16 00 00    	jo     183524 <allocation_pmu_probe::main+0x1724>
  181f16:	83 c2 d0             	add    $0xffffffd0,%edx
  181f19:	83 fa 0a             	cmp    $0xa,%edx
  181f1c:	0f 83 de 1a 00 00    	jae    183a00 <allocation_pmu_probe::main+0x1c00>
  181f22:	89 d2                	mov    %edx,%edx
  181f24:	49 ff c0             	inc    %r8
  181f27:	48 01 d0             	add    %rdx,%rax
  181f2a:	73 d4                	jae    181f00 <allocation_pmu_probe::main+0x100>
  181f2c:	b0 02                	mov    $0x2,%al
  181f2e:	e9 fb 15 00 00       	jmp    18352e <allocation_pmu_probe::main+0x172e>
  181f33:	31 c0                	xor    %eax,%eax
  181f35:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  181f3c:	00 
  181f3d:	49 8b 4f 20          	mov    0x20(%r15),%rcx
  181f41:	49 8b 77 28          	mov    0x28(%r15),%rsi
  181f45:	48 83 fe 01          	cmp    $0x1,%rsi
  181f49:	74 0e                	je     181f59 <allocation_pmu_probe::main+0x159>
  181f4b:	48 85 f6             	test   %rsi,%rsi
  181f4e:	0f 84 44 1b 00 00    	je     183a98 <allocation_pmu_probe::main+0x1c98>
  181f54:	0f b6 11             	movzbl (%rcx),%edx
  181f57:	eb 17                	jmp    181f70 <allocation_pmu_probe::main+0x170>
  181f59:	0f b6 11             	movzbl (%rcx),%edx
  181f5c:	b0 01                	mov    $0x1,%al
  181f5e:	83 fa 2b             	cmp    $0x2b,%edx
  181f61:	0f 84 e1 15 00 00    	je     183548 <allocation_pmu_probe::main+0x1748>
  181f67:	83 fa 2d             	cmp    $0x2d,%edx
  181f6a:	0f 84 d8 15 00 00    	je     183548 <allocation_pmu_probe::main+0x1748>
  181f70:	31 c0                	xor    %eax,%eax
  181f72:	80 fa 2b             	cmp    $0x2b,%dl
  181f75:	0f 94 c0             	sete   %al
  181f78:	48 89 f2             	mov    %rsi,%rdx
  181f7b:	48 29 c2             	sub    %rax,%rdx
  181f7e:	48 01 c1             	add    %rax,%rcx
  181f81:	48 f7 d8             	neg    %rax
  181f84:	48 83 fa 11          	cmp    $0x11,%rdx
  181f88:	73 44                	jae    181fce <allocation_pmu_probe::main+0x1ce>
  181f8a:	48 85 d2             	test   %rdx,%rdx
  181f8d:	0f 84 86 00 00 00    	je     182019 <allocation_pmu_probe::main+0x219>
  181f93:	48 01 c6             	add    %rax,%rsi
  181f96:	48 f7 de             	neg    %rsi
  181f99:	45 31 ed             	xor    %r13d,%r13d
  181f9c:	31 c0                	xor    %eax,%eax
  181f9e:	66 90                	xchg   %ax,%ax
  181fa0:	0f b6 14 01          	movzbl (%rcx,%rax,1),%edx
  181fa4:	83 c2 d0             	add    $0xffffffd0,%edx
  181fa7:	83 fa 09             	cmp    $0x9,%edx
  181faa:	0f 87 57 1a 00 00    	ja     183a07 <allocation_pmu_probe::main+0x1c07>
  181fb0:	4a 8d 3c ad 00 00 00 	lea    0x0(,%r13,4),%rdi
  181fb7:	00 
  181fb8:	4c 01 ef             	add    %r13,%rdi
  181fbb:	89 d2                	mov    %edx,%edx
  181fbd:	4c 8d 2c 7a          	lea    (%rdx,%rdi,2),%r13
  181fc1:	48 ff c0             	inc    %rax
  181fc4:	48 89 f2             	mov    %rsi,%rdx
  181fc7:	48 01 c2             	add    %rax,%rdx
  181fca:	75 d4                	jne    181fa0 <allocation_pmu_probe::main+0x1a0>
  181fcc:	eb 4e                	jmp    18201c <allocation_pmu_probe::main+0x21c>
  181fce:	48 01 c6             	add    %rax,%rsi
  181fd1:	48 f7 de             	neg    %rsi
  181fd4:	45 31 ed             	xor    %r13d,%r13d
  181fd7:	bf 0a 00 00 00       	mov    $0xa,%edi
  181fdc:	45 31 c0             	xor    %r8d,%r8d
  181fdf:	90                   	nop
  181fe0:	48 89 f0             	mov    %rsi,%rax
  181fe3:	4c 01 c0             	add    %r8,%rax
  181fe6:	74 34                	je     18201c <allocation_pmu_probe::main+0x21c>
  181fe8:	4c 89 e8             	mov    %r13,%rax
  181feb:	48 f7 e7             	mul    %rdi
  181fee:	42 0f b6 14 01       	movzbl (%rcx,%r8,1),%edx
  181ff3:	0f 80 45 15 00 00    	jo     18353e <allocation_pmu_probe::main+0x173e>
  181ff9:	83 c2 d0             	add    $0xffffffd0,%edx
  181ffc:	83 fa 0a             	cmp    $0xa,%edx
  181fff:	0f 83 02 1a 00 00    	jae    183a07 <allocation_pmu_probe::main+0x1c07>
  182005:	49 89 c5             	mov    %rax,%r13
  182008:	89 d0                	mov    %edx,%eax
  18200a:	49 ff c0             	inc    %r8
  18200d:	49 01 c5             	add    %rax,%r13
  182010:	73 ce                	jae    181fe0 <allocation_pmu_probe::main+0x1e0>
  182012:	b0 02                	mov    $0x2,%al
  182014:	e9 2f 15 00 00       	jmp    183548 <allocation_pmu_probe::main+0x1748>
  182019:	45 31 ed             	xor    %r13d,%r13d
  18201c:	49 8b 47 40          	mov    0x40(%r15),%rax
  182020:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  182027:	00 
  182028:	48 83 f8 05          	cmp    $0x5,%rax
  18202c:	0f 85 fe 19 00 00    	jne    183a30 <allocation_pmu_probe::main+0x1c30>
  182032:	49 8b 57 38          	mov    0x38(%r15),%rdx
  182036:	b8 61 6c 6c 6f       	mov    $0x6f6c6c61,%eax
  18203b:	33 02                	xor    (%rdx),%eax
  18203d:	0f b6 4a 04          	movzbl 0x4(%rdx),%ecx
  182041:	83 f1 63             	xor    $0x63,%ecx
  182044:	09 c1                	or     %eax,%ecx
  182046:	74 16                	je     18205e <allocation_pmu_probe::main+0x25e>
  182048:	b8 65 6d 70 74       	mov    $0x74706d65,%eax
  18204d:	33 02                	xor    (%rdx),%eax
  18204f:	0f b6 4a 04          	movzbl 0x4(%rdx),%ecx
  182053:	83 f1 79             	xor    $0x79,%ecx
  182056:	09 c1                	or     %eax,%ecx
  182058:	0f 85 d2 19 00 00    	jne    183a30 <allocation_pmu_probe::main+0x1c30>
  18205e:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  182065:	00 
  182066:	48 bb 00 00 00 00 b6 	movabs $0x1b600000000,%rbx
  18206d:	01 00 00 
  182070:	48 89 9c 24 78 02 00 	mov    %rbx,0x278(%rsp)
  182077:	00 
  182078:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
  18207f:	00 00 00 00 
  182083:	66 c7 84 24 84 02 00 	movw   $0x0,0x284(%rsp)
  18208a:	00 00 00 
  18208d:	c6 84 24 81 02 00 00 	movb   $0x1,0x281(%rsp)
  182094:	01 
  182095:	49 8b 57 50          	mov    0x50(%r15),%rdx
  182099:	49 8b 4f 58          	mov    0x58(%r15),%rcx
  18209d:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  1820a4:	00 
  1820a5:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  1820ac:	00 
  1820ad:	ff 15 5d cd 4b 00    	call   *0x4bcd5d(%rip)        # 63ee10 <_DYNAMIC+0x780>
  1820b3:	83 bc 24 a0 08 00 00 	cmpl   $0x1,0x8a0(%rsp)
  1820ba:	01 
  1820bb:	0f 84 35 15 00 00    	je     1835f6 <allocation_pmu_probe::main+0x17f6>
  1820c1:	8b 84 24 a4 08 00 00 	mov    0x8a4(%rsp),%eax
  1820c8:	89 44 24 60          	mov    %eax,0x60(%rsp)
  1820cc:	48 89 9c 24 78 02 00 	mov    %rbx,0x278(%rsp)
  1820d3:	00 
  1820d4:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
  1820db:	00 00 00 00 
  1820df:	66 c7 84 24 84 02 00 	movw   $0x0,0x284(%rsp)
  1820e6:	00 00 00 
  1820e9:	c6 84 24 80 02 00 00 	movb   $0x1,0x280(%rsp)
  1820f0:	01 
  1820f1:	49 8b 57 68          	mov    0x68(%r15),%rdx
  1820f5:	49 8b 4f 70          	mov    0x70(%r15),%rcx
  1820f9:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  182100:	00 
  182101:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  182108:	00 
  182109:	ff 15 01 cd 4b 00    	call   *0x4bcd01(%rip)        # 63ee10 <_DYNAMIC+0x780>
  18210f:	83 bc 24 a0 08 00 00 	cmpl   $0x1,0x8a0(%rsp)
  182116:	01 
  182117:	0f 84 16 15 00 00    	je     183633 <allocation_pmu_probe::main+0x1833>
  18211d:	8b 84 24 a4 08 00 00 	mov    0x8a4(%rsp),%eax
  182124:	89 44 24 64          	mov    %eax,0x64(%rsp)
  182128:	49 8b b7 80 00 00 00 	mov    0x80(%r15),%rsi
  18212f:	49 8b 97 88 00 00 00 	mov    0x88(%r15),%rdx
  182136:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  18213d:	00 
  18213e:	ff 15 d4 cc 4b 00    	call   *0x4bccd4(%rip)        # 63ee18 <_DYNAMIC+0x788>
  182144:	48 83 bc 24 78 02 00 	cmpq   $0xffffffffffffffff,0x278(%rsp)
  18214b:	00 ff 
  18214d:	0f 84 1d 15 00 00    	je     183670 <allocation_pmu_probe::main+0x1870>
  182153:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
  18215a:	00 
  18215b:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  182162:	00 
  182163:	0f 10 84 24 78 02 00 	movups 0x278(%rsp),%xmm0
  18216a:	00 
  18216b:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  182172:	00 
  182173:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  18217a:	00 
  18217b:	48 89 84 24 a0 08 00 	mov    %rax,0x8a0(%rsp)
  182182:	00 
  182183:	48 8b 05 46 cb 4b 00 	mov    0x4bcb46(%rip),%rax        # 63ecd0 <_DYNAMIC+0x640>
  18218a:	48 89 84 24 a8 08 00 	mov    %rax,0x8a8(%rsp)
  182191:	00 
  182192:	48 8d 35 c1 b3 ee ff 	lea    -0x114c3f(%rip),%rsi        # 6d55a <anon.a9f1e0c66fa411ab12c76e8b10ce76a3.58.llvm.1726718357730413886+0x91>
  182199:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  1821a0:	00 
  1821a1:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  1821a8:	00 
  1821a9:	ff 15 29 c8 4b 00    	call   *0x4bc829(%rip)        # 63e9d8 <_DYNAMIC+0x348>
  1821af:	4c 8b b4 24 78 02 00 	mov    0x278(%rsp),%r14
  1821b6:	00 
  1821b7:	4c 8b a4 24 80 02 00 	mov    0x280(%rsp),%r12
  1821be:	00 
  1821bf:	48 8b 9c 24 88 02 00 	mov    0x288(%rsp),%rbx
  1821c6:	00 
  1821c7:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  1821ce:	00 
  1821cf:	e8 3c 36 fe ff       	call   165810 <<allocation_pmu_probe::fixture::Case as core::default::Default>::default>
  1821d4:	4c 89 b4 24 b0 01 00 	mov    %r14,0x1b0(%rsp)
  1821db:	00 
  1821dc:	4c 89 b4 24 e8 01 00 	mov    %r14,0x1e8(%rsp)
  1821e3:	00 
  1821e4:	4c 89 a4 24 98 01 00 	mov    %r12,0x198(%rsp)
  1821eb:	00 
  1821ec:	4c 89 a4 24 f0 01 00 	mov    %r12,0x1f0(%rsp)
  1821f3:	00 
  1821f4:	48 89 9c 24 f8 01 00 	mov    %rbx,0x1f8(%rsp)
  1821fb:	00 
  1821fc:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  182203:	00 
  182204:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  18220b:	00 
  18220c:	0f 10 84 24 c8 02 00 	movups 0x2c8(%rsp),%xmm0
  182213:	00 
  182214:	0f 11 84 24 38 02 00 	movups %xmm0,0x238(%rsp)
  18221b:	00 
  18221c:	0f 10 84 24 d8 02 00 	movups 0x2d8(%rsp),%xmm0
  182223:	00 
  182224:	0f 11 84 24 48 02 00 	movups %xmm0,0x248(%rsp)
  18222b:	00 
  18222c:	0f 10 84 24 e8 02 00 	movups 0x2e8(%rsp),%xmm0
  182233:	00 
  182234:	0f 11 84 24 58 02 00 	movups %xmm0,0x258(%rsp)
  18223b:	00 
  18223c:	0f 10 84 24 90 02 00 	movups 0x290(%rsp),%xmm0
  182243:	00 
  182244:	0f 11 84 24 00 02 00 	movups %xmm0,0x200(%rsp)
  18224b:	00 
  18224c:	48 8b 84 24 a0 02 00 	mov    0x2a0(%rsp),%rax
  182253:	00 
  182254:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  18225b:	00 
  18225c:	0f 10 84 24 a8 02 00 	movups 0x2a8(%rsp),%xmm0
  182263:	00 
  182264:	0f 11 84 24 18 02 00 	movups %xmm0,0x218(%rsp)
  18226b:	00 
  18226c:	48 8b 84 24 b8 02 00 	mov    0x2b8(%rsp),%rax
  182273:	00 
  182274:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  18227b:	00 
  18227c:	4c 89 ac 24 68 02 00 	mov    %r13,0x268(%rsp)
  182283:	00 
  182284:	0f b6 84 24 00 03 00 	movzbl 0x300(%rsp),%eax
  18228b:	00 
  18228c:	88 84 24 70 02 00 00 	mov    %al,0x270(%rsp)
  182293:	48 8b b4 24 78 02 00 	mov    0x278(%rsp),%rsi
  18229a:	00 
  18229b:	48 85 f6             	test   %rsi,%rsi
  18229e:	74 13                	je     1822b3 <allocation_pmu_probe::main+0x4b3>
  1822a0:	48 8b bc 24 80 02 00 	mov    0x280(%rsp),%rdi
  1822a7:	00 
  1822a8:	ba 01 00 00 00       	mov    $0x1,%edx
  1822ad:	ff 15 4d c6 4b 00    	call   *0x4bc64d(%rip)        # 63e900 <_DYNAMIC+0x270>
  1822b3:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  1822ba:	00 
  1822bb:	48 8d b4 24 e8 01 00 	lea    0x1e8(%rsp),%rsi
  1822c2:	00 
  1822c3:	e8 18 24 fe ff       	call   1646e0 <allocation_pmu_probe::fixture::module>
  1822c8:	48 c7 84 24 b8 08 00 	movq   $0xffffffffffffffff,0x8b8(%rsp)
  1822cf:	00 ff ff ff ff 
  1822d4:	48 c7 84 24 c8 09 00 	movq   $0xffffffffffffffff,0x9c8(%rsp)
  1822db:	00 ff ff ff ff 
  1822e0:	48 c7 84 24 80 0a 00 	movq   $0x0,0xa80(%rsp)
  1822e7:	00 00 00 00 00 
  1822ec:	0f 57 c0             	xorps  %xmm0,%xmm0
  1822ef:	0f 11 84 24 90 0a 00 	movups %xmm0,0xa90(%rsp)
  1822f6:	00 
  1822f7:	48 c7 84 24 a0 08 00 	movq   $0x0,0x8a0(%rsp)
  1822fe:	00 00 00 00 00 
  182303:	48 c7 84 24 a8 08 00 	movq   $0x8,0x8a8(%rsp)
  18230a:	00 08 00 00 00 
  18230f:	48 c7 84 24 b0 08 00 	movq   $0x0,0x8b0(%rsp)
  182316:	00 00 00 00 00 
  18231b:	48 c7 84 24 f0 0a 00 	movq   $0x0,0xaf0(%rsp)
  182322:	00 00 00 00 00 
  182327:	0f 11 84 24 a8 0a 00 	movups %xmm0,0xaa8(%rsp)
  18232e:	00 
  18232f:	0f 11 84 24 c0 0a 00 	movups %xmm0,0xac0(%rsp)
  182336:	00 
  182337:	0f 11 84 24 d8 0a 00 	movups %xmm0,0xad8(%rsp)
  18233e:	00 
  18233f:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  182346:	00 
  182347:	48 8d b4 24 e8 01 00 	lea    0x1e8(%rsp),%rsi
  18234e:	00 
  18234f:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  182356:	00 
  182357:	e8 94 2a fe ff       	call   164df0 <allocation_pmu_probe::fixture::genesis>
  18235c:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  182363:	00 
  182364:	48 8d b4 24 a0 08 00 	lea    0x8a0(%rsp),%rsi
  18236b:	00 
  18236c:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  182373:	00 
  182374:	48 8d 8c 24 40 06 00 	lea    0x640(%rsp),%rcx
  18237b:	00 
  18237c:	e8 0f 66 fb ff       	call   138990 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::create>
  182381:	48 83 bc 24 78 02 00 	cmpq   $0xffffffffffffffff,0x278(%rsp)
  182388:	00 ff 
  18238a:	0f 84 1d 13 00 00    	je     1836ad <allocation_pmu_probe::main+0x18ad>
  182390:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  182397:	00 
  182398:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  18239f:	00 
  1823a0:	ba c8 03 00 00       	mov    $0x3c8,%edx
  1823a5:	ff 15 65 c5 4b 00    	call   *0x4bc565(%rip)        # 63e910 <memcpy@GLIBC_2.14>
  1823ab:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  1823b2:	00 00 
  1823b4:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  1823bb:	00 00 
  1823bd:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  1823c4:	00 00 
  1823c6:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  1823cd:	00 00 
  1823cf:	ff 15 1b c5 4b 00    	call   *0x4bc51b(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  1823d5:	bf 03 00 00 00       	mov    $0x3,%edi
  1823da:	be 01 00 00 00       	mov    $0x1,%esi
  1823df:	ff 15 13 c5 4b 00    	call   *0x4bc513(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  1823e5:	48 85 c0             	test   %rax,%rax
  1823e8:	0f 84 5d 16 00 00    	je     183a4b <allocation_pmu_probe::main+0x1c4b>
  1823ee:	49 89 c6             	mov    %rax,%r14
  1823f1:	c6 40 02 30          	movb   $0x30,0x2(%rax)
  1823f5:	66 c7 00 69 64       	movw   $0x6469,(%rax)
  1823fa:	48 c7 84 24 30 01 00 	movq   $0x3,0x130(%rsp)
  182401:	00 03 00 00 00 
  182406:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  18240d:	00 
  18240e:	48 c7 84 24 40 01 00 	movq   $0x3,0x140(%rsp)
  182415:	00 03 00 00 00 
  18241a:	ff 15 d0 c4 4b 00    	call   *0x4bc4d0(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182420:	bf 06 00 00 00       	mov    $0x6,%edi
  182425:	be 01 00 00 00       	mov    $0x1,%esi
  18242a:	ff 15 c8 c4 4b 00    	call   *0x4bc4c8(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182430:	48 85 c0             	test   %rax,%rax
  182433:	0f 84 24 16 00 00    	je     183a5d <allocation_pmu_probe::main+0x1c5d>
  182439:	66 c7 40 04 5f 30    	movw   $0x305f,0x4(%rax)
  18243f:	c7 00 6e 65 77 30    	movl   $0x3077656e,(%rax)
  182445:	c6 84 24 78 02 00 00 	movb   $0x3,0x278(%rsp)
  18244c:	03 
  18244d:	48 c7 84 24 80 02 00 	movq   $0x6,0x280(%rsp)
  182454:	00 06 00 00 00 
  182459:	48 89 84 24 88 02 00 	mov    %rax,0x288(%rsp)
  182460:	00 
  182461:	48 c7 84 24 90 02 00 	movq   $0x6,0x290(%rsp)
  182468:	00 06 00 00 00 
  18246d:	4c 8d b4 24 40 06 00 	lea    0x640(%rsp),%r14
  182474:	00 
  182475:	48 8d 6c 24 20       	lea    0x20(%rsp),%rbp
  18247a:	48 8d 9c 24 30 01 00 	lea    0x130(%rsp),%rbx
  182481:	00 
  182482:	48 8d 8c 24 78 02 00 	lea    0x278(%rsp),%rcx
  182489:	00 
  18248a:	4c 89 f7             	mov    %r14,%rdi
  18248d:	48 89 ee             	mov    %rbp,%rsi
  182490:	48 89 da             	mov    %rbx,%rdx
  182493:	e8 58 b1 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182498:	80 bc 24 40 06 00 00 	cmpb   $0xff,0x640(%rsp)
  18249f:	ff 
  1824a0:	74 0d                	je     1824af <allocation_pmu_probe::main+0x6af>
  1824a2:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  1824a9:	00 
  1824aa:	e8 21 ef ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  1824af:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  1824b4:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  1824b9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  1824be:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  1824c5:	00 
  1824c6:	c6 44 24 68 05       	movb   $0x5,0x68(%rsp)
  1824cb:	48 c7 84 24 38 01 00 	movq   $0x0,0x138(%rsp)
  1824d2:	00 00 00 00 00 
  1824d7:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  1824de:	00 00 00 00 00 
  1824e3:	c6 84 24 30 01 00 00 	movb   $0x5,0x130(%rsp)
  1824ea:	05 
  1824eb:	48 c7 84 24 40 06 00 	movq   $0xffffffffffffffff,0x640(%rsp)
  1824f2:	00 ff ff ff ff 
  1824f7:	48 83 ec 08          	sub    $0x8,%rsp
  1824fb:	48 8d 05 d9 24 ef ff 	lea    -0x10db27(%rip),%rax        # 749db <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xf2>
  182502:	4c 8d 54 24 70       	lea    0x70(%rsp),%r10
  182507:	48 8d 0d c7 24 ef ff 	lea    -0x10db39(%rip),%rcx        # 749d5 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xec>
  18250e:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
  182515:	00 
  182516:	48 8d b4 24 a8 08 00 	lea    0x8a8(%rsp),%rsi
  18251d:	00 
  18251e:	48 8d 94 24 70 0c 00 	lea    0xc70(%rsp),%rdx
  182525:	00 
  182526:	4c 8d 4c 24 10       	lea    0x10(%rsp),%r9
  18252b:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  182531:	41 56                	push   %r14
  182533:	6a 14                	push   $0x14
  182535:	50                   	push   %rax
  182536:	53                   	push   %rbx
  182537:	41 52                	push   %r10
  182539:	e8 32 76 fb ff       	call   139b70 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::evaluate>
  18253e:	48 83 c4 30          	add    $0x30,%rsp
  182542:	48 83 bc 24 78 02 00 	cmpq   $0xfffffffffffffffe,0x278(%rsp)
  182549:	00 fe 
  18254b:	0f 84 e9 11 00 00    	je     18373a <allocation_pmu_probe::main+0x193a>
  182551:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  182558:	00 
  182559:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  182560:	00 
  182561:	ba 58 02 00 00       	mov    $0x258,%edx
  182566:	ff 15 a4 c3 4b 00    	call   *0x4bc3a4(%rip)        # 63e910 <memcpy@GLIBC_2.14>
  18256c:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  182573:	00 
  182574:	e8 57 ee ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  182579:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  18257e:	e8 4d ee ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  182583:	45 31 f6             	xor    %r14d,%r14d
  182586:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  18258b:	e8 b0 21 fd ff       	call   154740 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  182590:	48 8d 94 24 78 08 00 	lea    0x878(%rsp),%rdx
  182597:	00 
  182598:	45 31 f6             	xor    %r14d,%r14d
  18259b:	48 8d 3d 4d 24 ef ff 	lea    -0x10dbb3(%rip),%rdi        # 749ef <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x106>
  1825a2:	be 06 00 00 00       	mov    $0x6,%esi
  1825a7:	ff 15 7b c4 4b 00    	call   *0x4bc47b(%rip)        # 63ea28 <_DYNAMIC+0x398>
  1825ad:	48 85 c0             	test   %rax,%rax
  1825b0:	75 07                	jne    1825b9 <allocation_pmu_probe::main+0x7b9>
  1825b2:	48 8b 05 77 c4 4b 00 	mov    0x4bc477(%rip),%rax        # 63ea30 <_DYNAMIC+0x3a0>
  1825b9:	80 38 03             	cmpb   $0x3,(%rax)
  1825bc:	0f 85 b5 0f 00 00    	jne    183577 <allocation_pmu_probe::main+0x1777>
  1825c2:	48 83 78 18 05       	cmpq   $0x5,0x18(%rax)
  1825c7:	0f 85 aa 0f 00 00    	jne    183577 <allocation_pmu_probe::main+0x1777>
  1825cd:	48 8b 48 10          	mov    0x10(%rax),%rcx
  1825d1:	ba 41 4c 4c 4f       	mov    $0x4f4c4c41,%edx
  1825d6:	33 11                	xor    (%rcx),%edx
  1825d8:	0f b6 49 04          	movzbl 0x4(%rcx),%ecx
  1825dc:	83 f1 57             	xor    $0x57,%ecx
  1825df:	09 d1                	or     %edx,%ecx
  1825e1:	0f 85 90 0f 00 00    	jne    183577 <allocation_pmu_probe::main+0x1777>
  1825e7:	48 8b 84 24 40 06 00 	mov    0x640(%rsp),%rax
  1825ee:	00 
  1825ef:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1825f3:	0f 84 ce 11 00 00    	je     1837c7 <allocation_pmu_probe::main+0x19c7>
  1825f9:	48 8d b4 24 48 06 00 	lea    0x648(%rsp),%rsi
  182600:	00 
  182601:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  182608:	00 
  182609:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
  182610:	00 
  182611:	ba 30 02 00 00       	mov    $0x230,%edx
  182616:	ff 15 f4 c2 4b 00    	call   *0x4bc2f4(%rip)        # 63e910 <memcpy@GLIBC_2.14>
  18261c:	48 8d 8c 24 90 02 00 	lea    0x290(%rsp),%rcx
  182623:	00 
  182624:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  182629:	48 8d b4 24 a0 08 00 	lea    0x8a0(%rsp),%rsi
  182630:	00 
  182631:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  182638:	00 
  182639:	4c 8d 84 24 78 02 00 	lea    0x278(%rsp),%r8
  182640:	00 
  182641:	48 89 df             	mov    %rbx,%rdi
  182644:	45 31 c9             	xor    %r9d,%r9d
  182647:	e8 14 79 fa ff       	call   129f60 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::commit_impl>
  18264c:	48 83 7c 24 68 ff    	cmpq   $0xffffffffffffffff,0x68(%rsp)
  182652:	0f 85 84 11 00 00    	jne    1837dc <allocation_pmu_probe::main+0x19dc>
  182658:	0f 10 84 24 b0 00 00 	movups 0xb0(%rsp),%xmm0
  18265f:	00 
  182660:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  182667:	00 
  182668:	0f 10 44 24 70       	movups 0x70(%rsp),%xmm0
  18266d:	0f 10 8c 24 80 00 00 	movups 0x80(%rsp),%xmm1
  182674:	00 
  182675:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  18267c:	00 
  18267d:	0f 10 9c 24 a0 00 00 	movups 0xa0(%rsp),%xmm3
  182684:	00 
  182685:	0f 29 9c 24 60 01 00 	movaps %xmm3,0x160(%rsp)
  18268c:	00 
  18268d:	0f 29 94 24 50 01 00 	movaps %xmm2,0x150(%rsp)
  182694:	00 
  182695:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
  18269c:	00 
  18269d:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  1826a4:	00 
  1826a5:	80 bc 24 78 01 00 00 	cmpb   $0x0,0x178(%rsp)
  1826ac:	00 
  1826ad:	0f 85 b0 11 00 00    	jne    183863 <allocation_pmu_probe::main+0x1a63>
  1826b3:	48 83 bc 24 60 01 00 	cmpq   $0x1,0x160(%rsp)
  1826ba:	00 01 
  1826bc:	0f 85 bf 11 00 00    	jne    183881 <allocation_pmu_probe::main+0x1a81>
  1826c2:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  1826c7:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
  1826cc:	ba 01 00 00 00       	mov    $0x1,%edx
  1826d1:	e8 da 17 00 00       	call   183eb0 <allocation_pmu_probe::control>
  1826d6:	ff 15 d4 c7 4b 00    	call   *0x4bc7d4(%rip)        # 63eeb0 <_DYNAMIC+0x820>
  1826dc:	48 89 84 24 c8 01 00 	mov    %rax,0x1c8(%rsp)
  1826e3:	00 
  1826e4:	89 94 24 d0 01 00 00 	mov    %edx,0x1d0(%rsp)
  1826eb:	b8 61 6c 6c 6f       	mov    $0x6f6c6c61,%eax
  1826f0:	48 8b 8c 24 28 01 00 	mov    0x128(%rsp),%rcx
  1826f7:	00 
  1826f8:	33 01                	xor    (%rcx),%eax
  1826fa:	0f b6 49 04          	movzbl 0x4(%rcx),%ecx
  1826fe:	83 f1 63             	xor    $0x63,%ecx
  182701:	09 c1                	or     %eax,%ecx
  182703:	74 23                	je     182728 <allocation_pmu_probe::main+0x928>
  182705:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  18270c:	00 
  18270d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  182714:	00 
  182715:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  18271a:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  18271f:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  182726:	eb 72                	jmp    18279a <allocation_pmu_probe::main+0x99a>
  182728:	4c 8b b4 24 20 01 00 	mov    0x120(%rsp),%r14
  18272f:	00 
  182730:	4d 85 f6             	test   %r14,%r14
  182733:	74 2c                	je     182761 <allocation_pmu_probe::main+0x961>
  182735:	ff 15 b5 c1 4b 00    	call   *0x4bc1b5(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  18273b:	be 01 00 00 00       	mov    $0x1,%esi
  182740:	4c 89 f7             	mov    %r14,%rdi
  182743:	ff 15 af c1 4b 00    	call   *0x4bc1af(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182749:	48 85 c0             	test   %rax,%rax
  18274c:	75 18                	jne    182766 <allocation_pmu_probe::main+0x966>
  18274e:	bf 01 00 00 00       	mov    $0x1,%edi
  182753:	4c 89 f6             	mov    %r14,%rsi
  182756:	ff 15 1c c2 4b 00    	call   *0x4bc21c(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  18275c:	e9 4c 13 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  182761:	b8 01 00 00 00       	mov    $0x1,%eax
  182766:	4c 89 b4 24 e8 00 00 	mov    %r14,0xe8(%rsp)
  18276d:	00 
  18276e:	4c 89 74 24 68       	mov    %r14,0x68(%rsp)
  182773:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  182778:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  18277f:	00 00 
  182781:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  182786:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  18278b:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
  182790:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  182795:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  18279a:	48 8d bc 24 c8 01 00 	lea    0x1c8(%rsp),%rdi
  1827a1:	00 
  1827a2:	ff 15 10 c7 4b 00    	call   *0x4bc710(%rip)        # 63eeb8 <_DYNAMIC+0x828>
  1827a8:	89 d1                	mov    %edx,%ecx
  1827aa:	ba 00 ca 9a 3b       	mov    $0x3b9aca00,%edx
  1827af:	48 f7 e2             	mul    %rdx
  1827b2:	89 c9                	mov    %ecx,%ecx
  1827b4:	48 01 c1             	add    %rax,%rcx
  1827b7:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  1827be:	00 
  1827bf:	48 83 d2 00          	adc    $0x0,%rdx
  1827c3:	48 89 94 24 a8 01 00 	mov    %rdx,0x1a8(%rsp)
  1827ca:	00 
  1827cb:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  1827d0:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
  1827d5:	31 d2                	xor    %edx,%edx
  1827d7:	e8 d4 16 00 00       	call   183eb0 <allocation_pmu_probe::control>
  1827dc:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  1827e0:	75 37                	jne    182819 <allocation_pmu_probe::main+0xa19>
  1827e2:	4c 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%r14
  1827e9:	00 
  1827ea:	4d 85 f6             	test   %r14,%r14
  1827ed:	74 22                	je     182811 <allocation_pmu_probe::main+0xa11>
  1827ef:	ff 15 fb c0 4b 00    	call   *0x4bc0fb(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  1827f5:	be 01 00 00 00       	mov    $0x1,%esi
  1827fa:	4c 89 f7             	mov    %r14,%rdi
  1827fd:	ff 15 f5 c0 4b 00    	call   *0x4bc0f5(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182803:	48 85 c0             	test   %rax,%rax
  182806:	0f 84 93 12 00 00    	je     183a9f <allocation_pmu_probe::main+0x1c9f>
  18280c:	49 89 c4             	mov    %rax,%r12
  18280f:	eb 06                	jmp    182817 <allocation_pmu_probe::main+0xa17>
  182811:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  182817:	31 db                	xor    %ebx,%ebx
  182819:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
  18281e:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
  182823:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  182828:	4c 89 b4 24 c0 01 00 	mov    %r14,0x1c0(%rsp)
  18282f:	00 
  182830:	ff 15 7a c6 4b 00    	call   *0x4bc67a(%rip)        # 63eeb0 <_DYNAMIC+0x820>
  182836:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
  18283d:	00 
  18283e:	89 94 24 e0 01 00 00 	mov    %edx,0x1e0(%rsp)
  182845:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
  18284a:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  18284f:	0f b6 84 24 78 08 00 	movzbl 0x878(%rsp),%eax
  182856:	00 
  182857:	48 8d 0d e6 20 ef ff 	lea    -0x10df1a(%rip),%rcx        # 74944 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x5b>
  18285e:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  182862:	48 01 c8             	add    %rcx,%rax
  182865:	ff e0                	jmp    *%rax
  182867:	bb 04 00 00 00       	mov    $0x4,%ebx
  18286c:	4c 8d 25 4d 07 ef ff 	lea    -0x10f8b3(%rip),%r12        # 72fc0 <anon.e8c9979099957ea97e14e3734d806e91.7.llvm.12140543486298777174>
  182873:	e9 b2 00 00 00       	jmp    18292a <allocation_pmu_probe::main+0xb2a>
  182878:	48 8d b4 24 80 08 00 	lea    0x880(%rsp),%rsi
  18287f:	00 
  182880:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182885:	e8 d6 26 ff ff       	call   174f60 <<&mut serde_json::ser::Serializer<&mut alloc::vec::Vec<u8>> as serde_core::ser::Serializer>::collect_seq::<&alloc::vec::Vec<serde_json::value::Value>>>
  18288a:	eb 12                	jmp    18289e <allocation_pmu_probe::main+0xa9e>
  18288c:	48 8d bc 24 80 08 00 	lea    0x880(%rsp),%rdi
  182893:	00 
  182894:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  182899:	e8 72 3e ff ff       	call   176710 <<serde_json::number::Number as serde_core::ser::Serialize>::serialize::<&mut serde_json::ser::Serializer<&mut alloc::vec::Vec<u8>>>>
  18289e:	48 85 c0             	test   %rax,%rax
  1828a1:	0f 84 7a 03 00 00    	je     182c21 <allocation_pmu_probe::main+0xe21>
  1828a7:	eb 31                	jmp    1828da <allocation_pmu_probe::main+0xada>
  1828a9:	48 8b 94 24 88 08 00 	mov    0x888(%rsp),%rdx
  1828b0:	00 
  1828b1:	48 8b 8c 24 90 08 00 	mov    0x890(%rsp),%rcx
  1828b8:	00 
  1828b9:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  1828be:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1828c3:	e8 a8 0d ff ff       	call   173670 <serde_json::ser::format_escaped_str::<&mut alloc::vec::Vec<u8>, serde_json::ser::CompactFormatter>>
  1828c8:	48 85 c0             	test   %rax,%rax
  1828cb:	0f 84 50 03 00 00    	je     182c21 <allocation_pmu_probe::main+0xe21>
  1828d1:	48 89 c7             	mov    %rax,%rdi
  1828d4:	ff 15 e6 c5 4b 00    	call   *0x4bc5e6(%rip)        # 63eec0 <_DYNAMIC+0x830>
  1828da:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  1828df:	48 8d 3d 93 21 ef ff 	lea    -0x10de6d(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1828e6:	48 8d 0d 83 27 4b 00 	lea    0x4b2783(%rip),%rcx        # 635070 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  1828ed:	4c 8d 05 14 26 4b 00 	lea    0x4b2614(%rip),%r8        # 634f08 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x118>
  1828f4:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  1828f9:	be 2b 00 00 00       	mov    $0x2b,%esi
  1828fe:	ff 15 ec c0 4b 00    	call   *0x4bc0ec(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  182904:	e9 a4 11 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  182909:	0f b6 9c 24 79 08 00 	movzbl 0x879(%rsp),%ebx
  182910:	00 
  182911:	48 8d 05 bc 06 ef ff 	lea    -0x10f944(%rip),%rax        # 72fd4 <anon.1cb71ff3762624ae304e4a0523993dab.9.llvm.2568929261584004968>
  182918:	4c 8d 25 7d 20 ef ff 	lea    -0x10df83(%rip),%r12        # 7499c <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xb3>
  18291f:	48 85 db             	test   %rbx,%rbx
  182922:	4c 0f 45 e0          	cmovne %rax,%r12
  182926:	48 83 f3 05          	xor    $0x5,%rbx
  18292a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  18292f:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  182934:	48 29 e8             	sub    %rbp,%rax
  182937:	48 39 c3             	cmp    %rax,%rbx
  18293a:	0f 87 20 10 00 00    	ja     183960 <allocation_pmu_probe::main+0x1b60>
  182940:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  182945:	48 01 ef             	add    %rbp,%rdi
  182948:	4c 89 e6             	mov    %r12,%rsi
  18294b:	48 89 da             	mov    %rbx,%rdx
  18294e:	ff 15 bc bf 4b 00    	call   *0x4bbfbc(%rip)        # 63e910 <memcpy@GLIBC_2.14>
  182954:	48 01 dd             	add    %rbx,%rbp
  182957:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  18295c:	e9 c0 02 00 00       	jmp    182c21 <allocation_pmu_probe::main+0xe21>
  182961:	4c 8b a4 24 90 08 00 	mov    0x890(%rsp),%r12
  182968:	00 
  182969:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  18296e:	48 39 74 24 48       	cmp    %rsi,0x48(%rsp)
  182973:	0f 84 0c 10 00 00    	je     183985 <allocation_pmu_probe::main+0x1b85>
  182979:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  18297e:	c6 04 30 7b          	movb   $0x7b,(%rax,%rsi,1)
  182982:	48 ff c6             	inc    %rsi
  182985:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  18298a:	b0 01                	mov    $0x1,%al
  18298c:	4d 85 e4             	test   %r12,%r12
  18298f:	75 1e                	jne    1829af <allocation_pmu_probe::main+0xbaf>
  182991:	48 39 74 24 48       	cmp    %rsi,0x48(%rsp)
  182996:	0f 84 40 10 00 00    	je     1839dc <allocation_pmu_probe::main+0x1bdc>
  18299c:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  1829a1:	c6 04 30 7d          	movb   $0x7d,(%rax,%rsi,1)
  1829a5:	48 ff c6             	inc    %rsi
  1829a8:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  1829ad:	31 c0                	xor    %eax,%eax
  1829af:	4c 89 b4 24 e0 00 00 	mov    %r14,0xe0(%rsp)
  1829b6:	00 
  1829b7:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
  1829bc:	88 44 24 70          	mov    %al,0x70(%rsp)
  1829c0:	48 8b 8c 24 80 08 00 	mov    0x880(%rsp),%rcx
  1829c7:	00 
  1829c8:	4c 8b b4 24 88 08 00 	mov    0x888(%rsp),%r14
  1829cf:	00 
  1829d0:	48 85 c9             	test   %rcx,%rcx
  1829d3:	0f 95 c2             	setne  %dl
  1829d6:	4c 0f 44 e1          	cmove  %rcx,%r12
  1829da:	31 ed                	xor    %ebp,%ebp
  1829dc:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  1829e1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1829e8:	0f 1f 84 00 00 00 00 
  1829ef:	00 
  1829f0:	49 83 ec 01          	sub    $0x1,%r12
  1829f4:	0f 82 f4 01 00 00    	jb     182bee <allocation_pmu_probe::main+0xdee>
  1829fa:	f6 c2 01             	test   $0x1,%dl
  1829fd:	0f 84 1e 10 00 00    	je     183a21 <allocation_pmu_probe::main+0x1c21>
  182a03:	48 85 ed             	test   %rbp,%rbp
  182a06:	74 28                	je     182a30 <allocation_pmu_probe::main+0xc30>
  182a08:	0f b7 85 72 02 00 00 	movzwl 0x272(%rbp),%eax
  182a0f:	49 39 c6             	cmp    %rax,%r14
  182a12:	0f 83 c8 00 00 00    	jae    182ae0 <allocation_pmu_probe::main+0xce0>
  182a18:	48 89 e8             	mov    %rbp,%rax
  182a1b:	4c 89 f2             	mov    %r14,%rdx
  182a1e:	e9 e3 00 00 00       	jmp    182b06 <allocation_pmu_probe::main+0xd06>
  182a23:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  182a2a:	84 00 00 00 00 00 
  182a30:	4d 85 f6             	test   %r14,%r14
  182a33:	74 38                	je     182a6d <allocation_pmu_probe::main+0xc6d>
  182a35:	4c 89 f0             	mov    %r14,%rax
  182a38:	48 89 cd             	mov    %rcx,%rbp
  182a3b:	48 83 e0 07          	and    $0x7,%rax
  182a3f:	74 31                	je     182a72 <allocation_pmu_probe::main+0xc72>
  182a41:	31 c9                	xor    %ecx,%ecx
  182a43:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  182a4a:	84 00 00 00 00 00 
  182a50:	48 8b ad 78 02 00 00 	mov    0x278(%rbp),%rbp
  182a57:	48 ff c1             	inc    %rcx
  182a5a:	48 39 c8             	cmp    %rcx,%rax
  182a5d:	75 f1                	jne    182a50 <allocation_pmu_probe::main+0xc50>
  182a5f:	4c 89 f0             	mov    %r14,%rax
  182a62:	48 29 c8             	sub    %rcx,%rax
  182a65:	49 83 fe 08          	cmp    $0x8,%r14
  182a69:	73 15                	jae    182a80 <allocation_pmu_probe::main+0xc80>
  182a6b:	eb 51                	jmp    182abe <allocation_pmu_probe::main+0xcbe>
  182a6d:	48 89 cd             	mov    %rcx,%rbp
  182a70:	eb 4c                	jmp    182abe <allocation_pmu_probe::main+0xcbe>
  182a72:	4c 89 f0             	mov    %r14,%rax
  182a75:	49 83 fe 08          	cmp    $0x8,%r14
  182a79:	72 43                	jb     182abe <allocation_pmu_probe::main+0xcbe>
  182a7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  182a80:	48 8b 8d 78 02 00 00 	mov    0x278(%rbp),%rcx
  182a87:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182a8e:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182a95:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182a9c:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182aa3:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182aaa:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182ab1:	48 8b a9 78 02 00 00 	mov    0x278(%rcx),%rbp
  182ab8:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  182abc:	75 c2                	jne    182a80 <allocation_pmu_probe::main+0xc80>
  182abe:	45 31 f6             	xor    %r14d,%r14d
  182ac1:	31 c9                	xor    %ecx,%ecx
  182ac3:	0f b7 85 72 02 00 00 	movzwl 0x272(%rbp),%eax
  182aca:	49 39 c6             	cmp    %rax,%r14
  182acd:	0f 82 45 ff ff ff    	jb     182a18 <allocation_pmu_probe::main+0xc18>
  182ad3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  182ada:	84 00 00 00 00 00 
  182ae0:	48 8b 85 60 01 00 00 	mov    0x160(%rbp),%rax
  182ae7:	48 85 c0             	test   %rax,%rax
  182aea:	0f 84 b9 0e 00 00    	je     1839a9 <allocation_pmu_probe::main+0x1ba9>
  182af0:	48 ff c1             	inc    %rcx
  182af3:	0f b7 95 70 02 00 00 	movzwl 0x270(%rbp),%edx
  182afa:	48 89 c5             	mov    %rax,%rbp
  182afd:	66 3b 90 72 02 00 00 	cmp    0x272(%rax),%dx
  182b04:	73 da                	jae    182ae0 <allocation_pmu_probe::main+0xce0>
  182b06:	48 85 c9             	test   %rcx,%rcx
  182b09:	0f 84 91 00 00 00    	je     182ba0 <allocation_pmu_probe::main+0xda0>
  182b0f:	48 8d 34 d0          	lea    (%rax,%rdx,8),%rsi
  182b13:	48 81 c6 80 02 00 00 	add    $0x280,%rsi
  182b1a:	48 89 cf             	mov    %rcx,%rdi
  182b1d:	48 83 e7 07          	and    $0x7,%rdi
  182b21:	0f 84 b9 00 00 00    	je     182be0 <allocation_pmu_probe::main+0xde0>
  182b27:	45 31 c0             	xor    %r8d,%r8d
  182b2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  182b30:	48 8b 2e             	mov    (%rsi),%rbp
  182b33:	48 8d b5 78 02 00 00 	lea    0x278(%rbp),%rsi
  182b3a:	49 ff c0             	inc    %r8
  182b3d:	4c 39 c7             	cmp    %r8,%rdi
  182b40:	75 ee                	jne    182b30 <allocation_pmu_probe::main+0xd30>
  182b42:	48 89 cf             	mov    %rcx,%rdi
  182b45:	4c 29 c7             	sub    %r8,%rdi
  182b48:	48 83 f9 08          	cmp    $0x8,%rcx
  182b4c:	72 43                	jb     182b91 <allocation_pmu_probe::main+0xd91>
  182b4e:	66 90                	xchg   %ax,%ax
  182b50:	48 8b 0e             	mov    (%rsi),%rcx
  182b53:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182b5a:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182b61:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182b68:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182b6f:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182b76:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182b7d:	48 8b a9 78 02 00 00 	mov    0x278(%rcx),%rbp
  182b84:	48 8d b5 78 02 00 00 	lea    0x278(%rbp),%rsi
  182b8b:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  182b8f:	75 bf                	jne    182b50 <allocation_pmu_probe::main+0xd50>
  182b91:	45 31 f6             	xor    %r14d,%r14d
  182b94:	eb 11                	jmp    182ba7 <allocation_pmu_probe::main+0xda7>
  182b96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  182b9d:	00 00 00 
  182ba0:	4c 8d 72 01          	lea    0x1(%rdx),%r14
  182ba4:	48 89 c5             	mov    %rax,%rbp
  182ba7:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  182bab:	48 8d 34 c8          	lea    (%rax,%rcx,8),%rsi
  182baf:	48 81 c6 68 01 00 00 	add    $0x168,%rsi
  182bb6:	48 c1 e2 05          	shl    $0x5,%rdx
  182bba:	48 01 c2             	add    %rax,%rdx
  182bbd:	48 89 df             	mov    %rbx,%rdi
  182bc0:	e8 ab 1f ff ff       	call   174b70 <<serde_json::ser::Compound<&mut alloc::vec::Vec<u8>, serde_json::ser::CompactFormatter> as serde_core::ser::SerializeMap>::serialize_entry::<alloc::string::String, serde_json::value::Value>>
  182bc5:	b2 01                	mov    $0x1,%dl
  182bc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  182bcc:	48 85 c0             	test   %rax,%rax
  182bcf:	0f 84 1b fe ff ff    	je     1829f0 <allocation_pmu_probe::main+0xbf0>
  182bd5:	e9 00 fd ff ff       	jmp    1828da <allocation_pmu_probe::main+0xada>
  182bda:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  182be0:	48 89 cf             	mov    %rcx,%rdi
  182be3:	48 83 f9 08          	cmp    $0x8,%rcx
  182be7:	72 a8                	jb     182b91 <allocation_pmu_probe::main+0xd91>
  182be9:	e9 62 ff ff ff       	jmp    182b50 <allocation_pmu_probe::main+0xd50>
  182bee:	80 7c 24 70 00       	cmpb   $0x0,0x70(%rsp)
  182bf3:	4c 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14
  182bfa:	00 
  182bfb:	74 24                	je     182c21 <allocation_pmu_probe::main+0xe21>
  182bfd:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  182c02:	48 8b 18             	mov    (%rax),%rbx
  182c05:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  182c09:	48 39 33             	cmp    %rsi,(%rbx)
  182c0c:	0f 84 a9 0d 00 00    	je     1839bb <allocation_pmu_probe::main+0x1bbb>
  182c12:	48 8b 43 08          	mov    0x8(%rbx),%rax
  182c16:	c6 04 30 7d          	movb   $0x7d,(%rax,%rsi,1)
  182c1a:	48 ff c6             	inc    %rsi
  182c1d:	48 89 73 10          	mov    %rsi,0x10(%rbx)
  182c21:	48 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%rdi
  182c28:	00 
  182c29:	ff 15 89 c2 4b 00    	call   *0x4bc289(%rip)        # 63eeb8 <_DYNAMIC+0x828>
  182c2f:	89 d1                	mov    %edx,%ecx
  182c31:	ba 00 ca 9a 3b       	mov    $0x3b9aca00,%edx
  182c36:	48 f7 e2             	mul    %rdx
  182c39:	49 89 d4             	mov    %rdx,%r12
  182c3c:	89 cb                	mov    %ecx,%ebx
  182c3e:	48 01 c3             	add    %rax,%rbx
  182c41:	49 83 d4 00          	adc    $0x0,%r12
  182c45:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  182c4a:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  182c4f:	49 39 c6             	cmp    %rax,%r14
  182c52:	0f 85 4e 0c 00 00    	jne    1838a6 <allocation_pmu_probe::main+0x1aa6>
  182c58:	49 8b bf 98 00 00 00 	mov    0x98(%r15),%rdi
  182c5f:	49 8b b7 a0 00 00 00 	mov    0xa0(%r15),%rsi
  182c66:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  182c6b:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  182c70:	ff 15 aa c1 4b 00    	call   *0x4bc1aa(%rip)        # 63ee20 <_DYNAMIC+0x790>
  182c76:	48 85 c0             	test   %rax,%rax
  182c79:	0f 85 4a 0c 00 00    	jne    1838c9 <allocation_pmu_probe::main+0x1ac9>
  182c7f:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
  182c86:	00 
  182c87:	48 39 54 24 58       	cmp    %rdx,0x58(%rsp)
  182c8c:	0f 85 07 09 00 00    	jne    183599 <allocation_pmu_probe::main+0x1799>
  182c92:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
  182c99:	00 
  182c9a:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  182c9f:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  182ca6:	00 
  182ca7:	ff 15 a3 bc 4b 00    	call   *0x4bbca3(%rip)        # 63e950 <bcmp@GLIBC_2.2.5>
  182cad:	85 c0                	test   %eax,%eax
  182caf:	0f 85 e4 08 00 00    	jne    183599 <allocation_pmu_probe::main+0x1799>
  182cb5:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  182cbc:	00 00 00 00 00 
  182cc1:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  182cc8:	00 00 00 00 00 
  182ccd:	ff 15 1d bc 4b 00    	call   *0x4bbc1d(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182cd3:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  182cd9:	bf 01 00 00 00       	mov    $0x1,%edi
  182cde:	be 01 00 00 00       	mov    $0x1,%esi
  182ce3:	ff 15 0f bc 4b 00    	call   *0x4bbc0f(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182ce9:	48 85 c0             	test   %rax,%rax
  182cec:	0f 84 1c 0d 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  182cf2:	c6 00 6e             	movb   $0x6e,(%rax)
  182cf5:	48 c7 44 24 08 01 00 	movq   $0x1,0x8(%rsp)
  182cfc:	00 00 
  182cfe:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182d03:	48 c7 44 24 18 01 00 	movq   $0x1,0x18(%rsp)
  182d0a:	00 00 
  182d0c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  182d13:	00 
  182d14:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182d19:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182d20:	00 00 
  182d22:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  182d27:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182d2c:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182d33:	00 
  182d34:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182d39:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182d3e:	e8 ad a8 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182d43:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182d48:	74 0a                	je     182d54 <allocation_pmu_probe::main+0xf54>
  182d4a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182d4f:	e8 7c e6 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  182d54:	ff 15 96 bb 4b 00    	call   *0x4bbb96(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182d5a:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  182d60:	bf 08 00 00 00       	mov    $0x8,%edi
  182d65:	be 01 00 00 00       	mov    $0x1,%esi
  182d6a:	ff 15 88 bb 4b 00    	call   *0x4bbb88(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182d70:	48 85 c0             	test   %rax,%rax
  182d73:	0f 84 95 0c 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  182d79:	48 b9 63 6f 6d 6d 61 	movabs $0x73646e616d6d6f63,%rcx
  182d80:	6e 64 73 
  182d83:	48 89 08             	mov    %rcx,(%rax)
  182d86:	48 c7 44 24 08 08 00 	movq   $0x8,0x8(%rsp)
  182d8d:	00 00 
  182d8f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182d94:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  182d9b:	00 00 
  182d9d:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182da2:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182da9:	00 00 
  182dab:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
  182db0:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182db5:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182dbc:	00 
  182dbd:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182dc2:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182dc7:	e8 24 a8 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182dcc:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182dd1:	74 0a                	je     182ddd <allocation_pmu_probe::main+0xfdd>
  182dd3:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182dd8:	e8 f3 e5 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  182ddd:	ff 15 0d bb 4b 00    	call   *0x4bbb0d(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182de3:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  182de9:	bf 04 00 00 00       	mov    $0x4,%edi
  182dee:	be 01 00 00 00       	mov    $0x1,%esi
  182df3:	ff 15 ff ba 4b 00    	call   *0x4bbaff(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182df9:	48 85 c0             	test   %rax,%rax
  182dfc:	0f 84 0c 0c 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  182e02:	49 89 c5             	mov    %rax,%r13
  182e05:	4c 89 f5             	mov    %r14,%rbp
  182e08:	c7 00 6d 6f 64 65    	movl   $0x65646f6d,(%rax)
  182e0e:	48 c7 44 24 08 04 00 	movq   $0x4,0x8(%rsp)
  182e15:	00 00 
  182e17:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182e1c:	48 c7 44 24 18 04 00 	movq   $0x4,0x18(%rsp)
  182e23:	00 00 
  182e25:	ff 15 c5 ba 4b 00    	call   *0x4bbac5(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182e2b:	be 01 00 00 00       	mov    $0x1,%esi
  182e30:	4c 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%r14
  182e37:	00 
  182e38:	4c 89 f7             	mov    %r14,%rdi
  182e3b:	ff 15 b7 ba 4b 00    	call   *0x4bbab7(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182e41:	48 85 c0             	test   %rax,%rax
  182e44:	0f 84 25 0c 00 00    	je     183a6f <allocation_pmu_probe::main+0x1c6f>
  182e4a:	49 89 c7             	mov    %rax,%r15
  182e4d:	48 89 c7             	mov    %rax,%rdi
  182e50:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  182e57:	00 
  182e58:	4c 89 f2             	mov    %r14,%rdx
  182e5b:	ff 15 af ba 4b 00    	call   *0x4bbaaf(%rip)        # 63e910 <memcpy@GLIBC_2.14>
  182e61:	c6 44 24 68 03       	movb   $0x3,0x68(%rsp)
  182e66:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
  182e6b:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
  182e70:	4c 89 b4 24 80 00 00 	mov    %r14,0x80(%rsp)
  182e77:	00 
  182e78:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182e7d:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182e84:	00 
  182e85:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182e8a:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182e8f:	e8 5c a7 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182e94:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182e99:	49 89 ee             	mov    %rbp,%r14
  182e9c:	74 0a                	je     182ea8 <allocation_pmu_probe::main+0x10a8>
  182e9e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182ea3:	e8 28 e5 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  182ea8:	ff 15 42 ba 4b 00    	call   *0x4bba42(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182eae:	41 bf 0b 00 00 00    	mov    $0xb,%r15d
  182eb4:	bf 0b 00 00 00       	mov    $0xb,%edi
  182eb9:	be 01 00 00 00       	mov    $0x1,%esi
  182ebe:	ff 15 34 ba 4b 00    	call   *0x4bba34(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182ec4:	48 85 c0             	test   %rax,%rax
  182ec7:	0f 84 41 0b 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  182ecd:	49 89 c5             	mov    %rax,%r13
  182ed0:	48 b8 64 69 61 67 6e 	movabs $0x74736f6e67616964,%rax
  182ed7:	6f 73 74 
  182eda:	49 89 45 00          	mov    %rax,0x0(%r13)
  182ede:	41 c7 45 07 74 69 63 	movl   $0x73636974,0x7(%r13)
  182ee5:	73 
  182ee6:	48 c7 44 24 08 0b 00 	movq   $0xb,0x8(%rsp)
  182eed:	00 00 
  182eef:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  182ef4:	48 c7 44 24 18 0b 00 	movq   $0xb,0x18(%rsp)
  182efb:	00 00 
  182efd:	ff 15 ed b9 4b 00    	call   *0x4bb9ed(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182f03:	bf 0e 00 00 00       	mov    $0xe,%edi
  182f08:	be 01 00 00 00       	mov    $0x1,%esi
  182f0d:	ff 15 e5 b9 4b 00    	call   *0x4bb9e5(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182f13:	48 85 c0             	test   %rax,%rax
  182f16:	0f 84 63 0b 00 00    	je     183a7f <allocation_pmu_probe::main+0x1c7f>
  182f1c:	48 b9 74 69 6f 6e 2d 	movabs $0x756d702d6e6f6974,%rcx
  182f23:	70 6d 75 
  182f26:	48 89 48 06          	mov    %rcx,0x6(%rax)
  182f2a:	48 b9 61 6c 6c 6f 63 	movabs $0x697461636f6c6c61,%rcx
  182f31:	61 74 69 
  182f34:	48 89 08             	mov    %rcx,(%rax)
  182f37:	c6 44 24 68 03       	movb   $0x3,0x68(%rsp)
  182f3c:	48 c7 44 24 70 0e 00 	movq   $0xe,0x70(%rsp)
  182f43:	00 00 
  182f45:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  182f4a:	48 c7 84 24 80 00 00 	movq   $0xe,0x80(%rsp)
  182f51:	00 0e 00 00 00 
  182f56:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182f5b:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182f62:	00 
  182f63:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182f68:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182f6d:	e8 7e a6 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182f72:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182f77:	74 0a                	je     182f83 <allocation_pmu_probe::main+0x1183>
  182f79:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182f7e:	e8 4d e4 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  182f83:	ff 15 67 b9 4b 00    	call   *0x4bb967(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  182f89:	41 bf 09 00 00 00    	mov    $0x9,%r15d
  182f8f:	bf 09 00 00 00       	mov    $0x9,%edi
  182f94:	be 01 00 00 00       	mov    $0x1,%esi
  182f99:	ff 15 59 b9 4b 00    	call   *0x4bb959(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  182f9f:	48 85 c0             	test   %rax,%rax
  182fa2:	0f 84 66 0a 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  182fa8:	49 89 c5             	mov    %rax,%r13
  182fab:	48 b8 77 69 6e 64 6f 	movabs $0x6e5f776f646e6977,%rax
  182fb2:	77 5f 6e 
  182fb5:	49 89 45 00          	mov    %rax,0x0(%r13)
  182fb9:	41 c6 45 08 73       	movb   $0x73,0x8(%r13)
  182fbe:	48 c7 44 24 08 09 00 	movq   $0x9,0x8(%rsp)
  182fc5:	00 00 
  182fc7:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  182fcc:	48 c7 44 24 18 09 00 	movq   $0x9,0x18(%rsp)
  182fd3:	00 00 
  182fd5:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182fda:	48 8b b4 24 a0 01 00 	mov    0x1a0(%rsp),%rsi
  182fe1:	00 
  182fe2:	48 8b 94 24 a8 01 00 	mov    0x1a8(%rsp),%rdx
  182fe9:	00 
  182fea:	ff 15 90 bd 4b 00    	call   *0x4bbd90(%rip)        # 63ed80 <_DYNAMIC+0x6f0>
  182ff0:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  182ff5:	0f 84 fd 08 00 00    	je     1838f8 <allocation_pmu_probe::main+0x1af8>
  182ffb:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  183000:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  183005:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  18300a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  18300f:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183014:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  18301b:	00 
  18301c:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  183021:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  183026:	e8 c5 a5 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  18302b:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  183030:	74 0a                	je     18303c <allocation_pmu_probe::main+0x123c>
  183032:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183037:	e8 94 e3 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  18303c:	ff 15 ae b8 4b 00    	call   *0x4bb8ae(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  183042:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  183048:	bf 08 00 00 00       	mov    $0x8,%edi
  18304d:	be 01 00 00 00       	mov    $0x1,%esi
  183052:	ff 15 a0 b8 4b 00    	call   *0x4bb8a0(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  183058:	48 85 c0             	test   %rax,%rax
  18305b:	0f 84 ad 09 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  183061:	49 89 c5             	mov    %rax,%r13
  183064:	48 b8 77 72 69 74 65 	movabs $0x736e5f6574697277,%rax
  18306b:	5f 6e 73 
  18306e:	49 89 45 00          	mov    %rax,0x0(%r13)
  183072:	48 c7 44 24 08 08 00 	movq   $0x8,0x8(%rsp)
  183079:	00 00 
  18307b:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  183080:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  183087:	00 00 
  183089:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  18308e:	48 89 de             	mov    %rbx,%rsi
  183091:	4c 89 e2             	mov    %r12,%rdx
  183094:	ff 15 e6 bc 4b 00    	call   *0x4bbce6(%rip)        # 63ed80 <_DYNAMIC+0x6f0>
  18309a:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  18309f:	0f 84 87 08 00 00    	je     18392c <allocation_pmu_probe::main+0x1b2c>
  1830a5:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  1830aa:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  1830af:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  1830b4:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  1830b9:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1830be:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  1830c5:	00 
  1830c6:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  1830cb:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  1830d0:	e8 1b a5 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  1830d5:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  1830da:	74 0a                	je     1830e6 <allocation_pmu_probe::main+0x12e6>
  1830dc:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1830e1:	e8 ea e2 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  1830e6:	ff 15 04 b8 4b 00    	call   *0x4bb804(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  1830ec:	41 bf 0c 00 00 00    	mov    $0xc,%r15d
  1830f2:	bf 0c 00 00 00       	mov    $0xc,%edi
  1830f7:	be 01 00 00 00       	mov    $0x1,%esi
  1830fc:	ff 15 f6 b7 4b 00    	call   *0x4bb7f6(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  183102:	48 85 c0             	test   %rax,%rax
  183105:	0f 84 03 09 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  18310b:	48 b9 72 65 63 6f 72 	movabs $0x625f64726f636572,%rcx
  183112:	64 5f 62 
  183115:	48 89 08             	mov    %rcx,(%rax)
  183118:	c7 40 08 79 74 65 73 	movl   $0x73657479,0x8(%rax)
  18311f:	48 c7 44 24 08 0c 00 	movq   $0xc,0x8(%rsp)
  183126:	00 00 
  183128:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  18312d:	48 c7 44 24 18 0c 00 	movq   $0xc,0x18(%rsp)
  183134:	00 00 
  183136:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  18313b:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  183140:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  183147:	00 00 
  183149:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  18314e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  183153:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  18315a:	00 
  18315b:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  183160:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  183165:	e8 86 a4 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  18316a:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  18316f:	74 0a                	je     18317b <allocation_pmu_probe::main+0x137b>
  183171:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  183176:	e8 55 e2 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  18317b:	ff 15 6f b7 4b 00    	call   *0x4bb76f(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  183181:	41 bf 0f 00 00 00    	mov    $0xf,%r15d
  183187:	bf 0f 00 00 00       	mov    $0xf,%edi
  18318c:	be 01 00 00 00       	mov    $0x1,%esi
  183191:	ff 15 61 b7 4b 00    	call   *0x4bb761(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  183197:	48 85 c0             	test   %rax,%rax
  18319a:	0f 84 6e 08 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  1831a0:	48 b9 79 5f 62 65 66 	movabs $0x65726f6665625f79,%rcx
  1831a7:	6f 72 65 
  1831aa:	48 89 48 07          	mov    %rcx,0x7(%rax)
  1831ae:	48 bb 63 61 70 61 63 	movabs $0x7974696361706163,%rbx
  1831b5:	69 74 79 
  1831b8:	48 89 18             	mov    %rbx,(%rax)
  1831bb:	48 c7 44 24 08 0f 00 	movq   $0xf,0x8(%rsp)
  1831c2:	00 00 
  1831c4:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  1831c9:	48 c7 44 24 18 0f 00 	movq   $0xf,0x18(%rsp)
  1831d0:	00 00 
  1831d2:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  1831d7:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  1831de:	00 00 
  1831e0:	4c 89 74 24 78       	mov    %r14,0x78(%rsp)
  1831e5:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1831ea:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  1831f1:	00 
  1831f2:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  1831f7:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  1831fc:	e8 ef a3 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  183201:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  183206:	74 0a                	je     183212 <allocation_pmu_probe::main+0x1412>
  183208:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18320d:	e8 be e1 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183212:	ff 15 d8 b6 4b 00    	call   *0x4bb6d8(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  183218:	41 bf 0e 00 00 00    	mov    $0xe,%r15d
  18321e:	bf 0e 00 00 00       	mov    $0xe,%edi
  183223:	be 01 00 00 00       	mov    $0x1,%esi
  183228:	ff 15 ca b6 4b 00    	call   *0x4bb6ca(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  18322e:	48 85 c0             	test   %rax,%rax
  183231:	0f 84 d7 07 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  183237:	48 b9 74 79 5f 61 66 	movabs $0x72657466615f7974,%rcx
  18323e:	74 65 72 
  183241:	48 89 48 06          	mov    %rcx,0x6(%rax)
  183245:	48 89 18             	mov    %rbx,(%rax)
  183248:	48 c7 44 24 08 0e 00 	movq   $0xe,0x8(%rsp)
  18324f:	00 00 
  183251:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  183256:	48 c7 44 24 18 0e 00 	movq   $0xe,0x18(%rsp)
  18325d:	00 00 
  18325f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  183264:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  183269:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  183270:	00 00 
  183272:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  183277:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18327c:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  183283:	00 
  183284:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  183289:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  18328e:	e8 5d a3 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  183293:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  183298:	74 0a                	je     1832a4 <allocation_pmu_probe::main+0x14a4>
  18329a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18329f:	e8 2c e1 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  1832a4:	ff 15 46 b6 4b 00    	call   *0x4bb646(%rip)        # 63e8f0 <_DYNAMIC+0x260>
  1832aa:	41 bf 09 00 00 00    	mov    $0x9,%r15d
  1832b0:	bf 09 00 00 00       	mov    $0x9,%edi
  1832b5:	be 01 00 00 00       	mov    $0x1,%esi
  1832ba:	ff 15 38 b6 4b 00    	call   *0x4bb638(%rip)        # 63e8f8 <_DYNAMIC+0x268>
  1832c0:	48 85 c0             	test   %rax,%rax
  1832c3:	0f 84 45 07 00 00    	je     183a0e <allocation_pmu_probe::main+0x1c0e>
  1832c9:	48 b9 61 63 6b 5f 62 	movabs $0x657479625f6b6361,%rcx
  1832d0:	79 74 65 
  1832d3:	48 89 08             	mov    %rcx,(%rax)
  1832d6:	c6 40 08 73          	movb   $0x73,0x8(%rax)
  1832da:	48 c7 44 24 08 09 00 	movq   $0x9,0x8(%rsp)
  1832e1:	00 00 
  1832e3:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  1832e8:	48 c7 44 24 18 09 00 	movq   $0x9,0x18(%rsp)
  1832ef:	00 00 
  1832f1:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  1832f6:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  1832fd:	00 00 
  1832ff:	48 c7 44 24 78 05 00 	movq   $0x5,0x78(%rsp)
  183306:	00 00 
  183308:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18330d:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  183314:	00 
  183315:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  18331a:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  18331f:	48 89 d9             	mov    %rbx,%rcx
  183322:	e8 c9 a2 fc ff       	call   14d5f0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  183327:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  18332c:	74 0a                	je     183338 <allocation_pmu_probe::main+0x1538>
  18332e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  183333:	e8 98 e0 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183338:	0f 10 84 24 c8 00 00 	movups 0xc8(%rsp),%xmm0
  18333f:	00 
  183340:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  183345:	48 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%rax
  18334c:	00 
  18334d:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  183354:	00 
  183355:	c6 44 24 68 05       	movb   $0x5,0x68(%rsp)
  18335a:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  18335f:	48 8b 05 7a b6 4b 00 	mov    0x4bb67a(%rip),%rax        # 63e9e0 <_DYNAMIC+0x350>
  183366:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  18336b:	48 8d 3d 5c 7c ee ff 	lea    -0x1183a4(%rip),%rdi        # 6afce <anon.e8c9979099957ea97e14e3734d806e91.11.llvm.12140543486298777174+0xf3>
  183372:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  183377:	ff 15 4b bb 4b 00    	call   *0x4bbb4b(%rip)        # 63eec8 <_DYNAMIC+0x838>
  18337d:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183382:	e8 49 e0 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183387:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  18338c:	48 85 f6             	test   %rsi,%rsi
  18338f:	74 10                	je     1833a1 <allocation_pmu_probe::main+0x15a1>
  183391:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  183396:	ba 01 00 00 00       	mov    $0x1,%edx
  18339b:	ff 15 5f b5 4b 00    	call   *0x4bb55f(%rip)        # 63e900 <_DYNAMIC+0x270>
  1833a1:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  1833a8:	00 
  1833a9:	48 85 f6             	test   %rsi,%rsi
  1833ac:	74 13                	je     1833c1 <allocation_pmu_probe::main+0x15c1>
  1833ae:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  1833b5:	00 
  1833b6:	ba 01 00 00 00       	mov    $0x1,%edx
  1833bb:	ff 15 3f b5 4b 00    	call   *0x4bb53f(%rip)        # 63e900 <_DYNAMIC+0x270>
  1833c1:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  1833c8:	00 
  1833c9:	48 85 f6             	test   %rsi,%rsi
  1833cc:	74 13                	je     1833e1 <allocation_pmu_probe::main+0x15e1>
  1833ce:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  1833d5:	00 
  1833d6:	ba 01 00 00 00       	mov    $0x1,%edx
  1833db:	ff 15 1f b5 4b 00    	call   *0x4bb51f(%rip)        # 63e900 <_DYNAMIC+0x270>
  1833e1:	41 b6 01             	mov    $0x1,%r14b
  1833e4:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  1833eb:	00 
  1833ec:	e8 5f da ff ff       	call   180e50 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  1833f1:	48 8d bc 24 78 08 00 	lea    0x878(%rsp),%rdi
  1833f8:	00 
  1833f9:	e8 d2 df ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  1833fe:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183405:	00 
  183406:	e8 25 cf ff ff       	call   180330 <core::ptr::drop_glue::<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>>
  18340b:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  183412:	00 
  183413:	e8 f8 e0 ff ff       	call   181510 <core::ptr::drop_glue::<behavior_core::semantic::module::Module>>
  183418:	48 8b b4 24 b0 01 00 	mov    0x1b0(%rsp),%rsi
  18341f:	00 
  183420:	48 85 f6             	test   %rsi,%rsi
  183423:	74 13                	je     183438 <allocation_pmu_probe::main+0x1638>
  183425:	ba 01 00 00 00       	mov    $0x1,%edx
  18342a:	48 8b bc 24 98 01 00 	mov    0x198(%rsp),%rdi
  183431:	00 
  183432:	ff 15 c8 b4 4b 00    	call   *0x4bb4c8(%rip)        # 63e900 <_DYNAMIC+0x270>
  183438:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  18343f:	00 
  183440:	48 85 f6             	test   %rsi,%rsi
  183443:	74 13                	je     183458 <allocation_pmu_probe::main+0x1658>
  183445:	48 8b bc 24 08 02 00 	mov    0x208(%rsp),%rdi
  18344c:	00 
  18344d:	ba 01 00 00 00       	mov    $0x1,%edx
  183452:	ff 15 a8 b4 4b 00    	call   *0x4bb4a8(%rip)        # 63e900 <_DYNAMIC+0x270>
  183458:	48 8b b4 24 18 02 00 	mov    0x218(%rsp),%rsi
  18345f:	00 
  183460:	48 85 f6             	test   %rsi,%rsi
  183463:	74 13                	je     183478 <allocation_pmu_probe::main+0x1678>
  183465:	48 8b bc 24 20 02 00 	mov    0x220(%rsp),%rdi
  18346c:	00 
  18346d:	ba 01 00 00 00       	mov    $0x1,%edx
  183472:	ff 15 88 b4 4b 00    	call   *0x4bb488(%rip)        # 63e900 <_DYNAMIC+0x270>
  183478:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
  18347f:	00 
  183480:	48 85 f6             	test   %rsi,%rsi
  183483:	74 13                	je     183498 <allocation_pmu_probe::main+0x1698>
  183485:	ba 01 00 00 00       	mov    $0x1,%edx
  18348a:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  183491:	00 
  183492:	ff 15 68 b4 4b 00    	call   *0x4bb468(%rip)        # 63e900 <_DYNAMIC+0x270>
  183498:	8b 7c 24 64          	mov    0x64(%rsp),%edi
  18349c:	48 8b 1d 2d ba 4b 00 	mov    0x4bba2d(%rip),%rbx        # 63eed0 <close@GLIBC_2.2.5>
  1834a3:	ff d3                	call   *%rbx
  1834a5:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  1834a9:	ff d3                	call   *%rbx
  1834ab:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
  1834b2:	00 
  1834b3:	4c 8b b4 24 08 01 00 	mov    0x108(%rsp),%r14
  1834ba:	00 
  1834bb:	4d 85 f6             	test   %r14,%r14
  1834be:	74 2f                	je     1834ef <allocation_pmu_probe::main+0x16ef>
  1834c0:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  1834c4:	4c 8b 25 35 b4 4b 00 	mov    0x4bb435(%rip),%r12        # 63e900 <_DYNAMIC+0x270>
  1834cb:	eb 0c                	jmp    1834d9 <allocation_pmu_probe::main+0x16d9>
  1834cd:	0f 1f 00             	nopl   (%rax)
  1834d0:	49 83 c7 18          	add    $0x18,%r15
  1834d4:	49 ff ce             	dec    %r14
  1834d7:	74 16                	je     1834ef <allocation_pmu_probe::main+0x16ef>
  1834d9:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  1834dd:	48 85 f6             	test   %rsi,%rsi
  1834e0:	74 ee                	je     1834d0 <allocation_pmu_probe::main+0x16d0>
  1834e2:	49 8b 3f             	mov    (%r15),%rdi
  1834e5:	ba 01 00 00 00       	mov    $0x1,%edx
  1834ea:	41 ff d4             	call   *%r12
  1834ed:	eb e1                	jmp    1834d0 <allocation_pmu_probe::main+0x16d0>
  1834ef:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  1834f6:	00 
  1834f7:	48 85 c0             	test   %rax,%rax
  1834fa:	74 16                	je     183512 <allocation_pmu_probe::main+0x1712>
  1834fc:	48 c1 e0 03          	shl    $0x3,%rax
  183500:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  183504:	ba 08 00 00 00       	mov    $0x8,%edx
  183509:	48 89 df             	mov    %rbx,%rdi
  18350c:	ff 15 ee b3 4b 00    	call   *0x4bb3ee(%rip)        # 63e900 <_DYNAMIC+0x270>
  183512:	48 81 c4 18 0e 00 00 	add    $0xe18,%rsp
  183519:	5b                   	pop    %rbx
  18351a:	41 5c                	pop    %r12
  18351c:	41 5d                	pop    %r13
  18351e:	41 5e                	pop    %r14
  183520:	41 5f                	pop    %r15
  183522:	5d                   	pop    %rbp
  183523:	c3                   	ret
  183524:	80 c2 d0             	add    $0xd0,%dl
  183527:	31 c0                	xor    %eax,%eax
  183529:	80 fa 0a             	cmp    $0xa,%dl
  18352c:	14 01                	adc    $0x1,%al
  18352e:	88 84 24 78 02 00 00 	mov    %al,0x278(%rsp)
  183535:	4c 8d 05 cc 18 4b 00 	lea    0x4b18cc(%rip),%r8        # 634e08 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x18>
  18353c:	eb 18                	jmp    183556 <allocation_pmu_probe::main+0x1756>
  18353e:	80 c2 d0             	add    $0xd0,%dl
  183541:	31 c0                	xor    %eax,%eax
  183543:	80 fa 0a             	cmp    $0xa,%dl
  183546:	14 01                	adc    $0x1,%al
  183548:	88 84 24 78 02 00 00 	mov    %al,0x278(%rsp)
  18354f:	4c 8d 05 ca 18 4b 00 	lea    0x4b18ca(%rip),%r8        # 634e20 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x30>
  183556:	48 8d 3d 1c 15 ef ff 	lea    -0x10eae4(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  18355d:	48 8d 0d 2c 1b 4b 00 	lea    0x4b1b2c(%rip),%rcx        # 635090 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x2a0>
  183564:	be 2b 00 00 00       	mov    $0x2b,%esi
  183569:	48 89 da             	mov    %rbx,%rdx
  18356c:	ff 15 7e b4 4b 00    	call   *0x4bb47e(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  183572:	e9 36 05 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183577:	45 31 f6             	xor    %r14d,%r14d
  18357a:	48 8d 15 47 19 4b 00 	lea    0x4b1947(%rip),%rdx        # 634ec8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xd8>
  183581:	4c 8d 0d 28 1a 4b 00 	lea    0x4b1a28(%rip),%r9        # 634fb0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1c0>
  183588:	31 ff                	xor    %edi,%edi
  18358a:	48 89 c6             	mov    %rax,%rsi
  18358d:	31 c9                	xor    %ecx,%ecx
  18358f:	e8 16 0f 00 00       	call   1844aa <core::panicking::assert_failed::<serde_json::value::Value, &str>>
  183594:	e9 14 05 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183599:	48 8d 0d 5a 14 ef ff 	lea    -0x10eba6(%rip),%rcx        # 749fa <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x111>
  1835a0:	4c 8d 0d a9 19 4b 00 	lea    0x4b19a9(%rip),%r9        # 634f50 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x160>
  1835a7:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
  1835ac:	48 8d 94 24 10 01 00 	lea    0x110(%rsp),%rdx
  1835b3:	00 
  1835b4:	41 b8 45 00 00 00    	mov    $0x45,%r8d
  1835ba:	31 ff                	xor    %edi,%edi
  1835bc:	e8 b6 0e 00 00       	call   184477 <core::panicking::assert_failed::<alloc::vec::Vec<u8>, alloc::vec::Vec<u8>>>
  1835c1:	e9 e7 04 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1835c6:	48 8d 15 c3 0b ef ff 	lea    -0x10f43d(%rip),%rdx        # 74190 <anon.f0ce8b4fff13ea61fcd41c9a7fbb4fc9.42.llvm.102737351613787692+0x10>
  1835cd:	48 8d 0d 6c 14 ef ff 	lea    -0x10eb94(%rip),%rcx        # 74a40 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x157>
  1835d4:	4c 8d 0d ed 19 4b 00 	lea    0x4b19ed(%rip),%r9        # 634fc8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1d8>
  1835db:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  1835e2:	00 
  1835e3:	41 b8 65 00 00 00    	mov    $0x65,%r8d
  1835e9:	31 ff                	xor    %edi,%edi
  1835eb:	ff 15 e7 b8 4b 00    	call   *0x4bb8e7(%rip)        # 63eed8 <_DYNAMIC+0x848>
  1835f1:	e9 b7 04 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1835f6:	48 8b 84 24 a8 08 00 	mov    0x8a8(%rsp),%rax
  1835fd:	00 
  1835fe:	48 89 84 24 40 06 00 	mov    %rax,0x640(%rsp)
  183605:	00 
  183606:	48 8d 3d 6c 14 ef ff 	lea    -0x10eb94(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  18360d:	48 8d 0d 1c 1a 4b 00 	lea    0x4b1a1c(%rip),%rcx        # 635030 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  183614:	4c 8d 05 35 18 4b 00 	lea    0x4b1835(%rip),%r8        # 634e50 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x60>
  18361b:	48 8d 94 24 40 06 00 	lea    0x640(%rsp),%rdx
  183622:	00 
  183623:	be 2b 00 00 00       	mov    $0x2b,%esi
  183628:	ff 15 c2 b3 4b 00    	call   *0x4bb3c2(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  18362e:	e9 7a 04 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183633:	48 8b 84 24 a8 08 00 	mov    0x8a8(%rsp),%rax
  18363a:	00 
  18363b:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  183642:	00 
  183643:	48 8d 3d 2f 14 ef ff 	lea    -0x10ebd1(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  18364a:	48 8d 0d df 19 4b 00 	lea    0x4b19df(%rip),%rcx        # 635030 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  183651:	4c 8d 05 10 18 4b 00 	lea    0x4b1810(%rip),%r8        # 634e68 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x78>
  183658:	48 8d 94 24 78 02 00 	lea    0x278(%rsp),%rdx
  18365f:	00 
  183660:	be 2b 00 00 00       	mov    $0x2b,%esi
  183665:	ff 15 85 b3 4b 00    	call   *0x4bb385(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  18366b:	e9 3d 04 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183670:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
  183677:	00 
  183678:	48 89 84 24 a0 08 00 	mov    %rax,0x8a0(%rsp)
  18367f:	00 
  183680:	48 8d 3d f2 13 ef ff 	lea    -0x10ec0e(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  183687:	48 8d 0d a2 19 4b 00 	lea    0x4b19a2(%rip),%rcx        # 635030 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  18368e:	4c 8d 05 eb 17 4b 00 	lea    0x4b17eb(%rip),%r8        # 634e80 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x90>
  183695:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  18369c:	00 
  18369d:	be 2b 00 00 00       	mov    $0x2b,%esi
  1836a2:	ff 15 48 b3 4b 00    	call   *0x4bb348(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  1836a8:	e9 00 04 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1836ad:	0f 10 84 24 d0 02 00 	movups 0x2d0(%rsp),%xmm0
  1836b4:	00 
  1836b5:	0f 29 84 24 f0 08 00 	movaps %xmm0,0x8f0(%rsp)
  1836bc:	00 
  1836bd:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  1836c4:	00 
  1836c5:	0f 29 84 24 e0 08 00 	movaps %xmm0,0x8e0(%rsp)
  1836cc:	00 
  1836cd:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  1836d4:	00 
  1836d5:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  1836dc:	00 
  1836dd:	0f 10 94 24 a0 02 00 	movups 0x2a0(%rsp),%xmm2
  1836e4:	00 
  1836e5:	0f 10 9c 24 b0 02 00 	movups 0x2b0(%rsp),%xmm3
  1836ec:	00 
  1836ed:	0f 29 9c 24 d0 08 00 	movaps %xmm3,0x8d0(%rsp)
  1836f4:	00 
  1836f5:	0f 29 94 24 c0 08 00 	movaps %xmm2,0x8c0(%rsp)
  1836fc:	00 
  1836fd:	0f 29 8c 24 b0 08 00 	movaps %xmm1,0x8b0(%rsp)
  183704:	00 
  183705:	0f 29 84 24 a0 08 00 	movaps %xmm0,0x8a0(%rsp)
  18370c:	00 
  18370d:	48 8d 3d 65 13 ef ff 	lea    -0x10ec9b(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  183714:	48 8d 0d 35 19 4b 00 	lea    0x4b1935(%rip),%rcx        # 635050 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  18371b:	4c 8d 05 76 17 4b 00 	lea    0x4b1776(%rip),%r8        # 634e98 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xa8>
  183722:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  183729:	00 
  18372a:	be 2b 00 00 00       	mov    $0x2b,%esi
  18372f:	ff 15 bb b2 4b 00    	call   *0x4bb2bb(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  183735:	e9 73 03 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  18373a:	0f 10 84 24 d0 02 00 	movups 0x2d0(%rsp),%xmm0
  183741:	00 
  183742:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  183749:	00 
  18374a:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  183751:	00 
  183752:	0f 29 84 24 80 06 00 	movaps %xmm0,0x680(%rsp)
  183759:	00 
  18375a:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  183761:	00 
  183762:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  183769:	00 
  18376a:	0f 10 94 24 a0 02 00 	movups 0x2a0(%rsp),%xmm2
  183771:	00 
  183772:	0f 10 9c 24 b0 02 00 	movups 0x2b0(%rsp),%xmm3
  183779:	00 
  18377a:	0f 29 9c 24 70 06 00 	movaps %xmm3,0x670(%rsp)
  183781:	00 
  183782:	0f 29 94 24 60 06 00 	movaps %xmm2,0x660(%rsp)
  183789:	00 
  18378a:	0f 29 8c 24 50 06 00 	movaps %xmm1,0x650(%rsp)
  183791:	00 
  183792:	0f 29 84 24 40 06 00 	movaps %xmm0,0x640(%rsp)
  183799:	00 
  18379a:	48 8d 3d d8 12 ef ff 	lea    -0x10ed28(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1837a1:	48 8d 0d a8 18 4b 00 	lea    0x4b18a8(%rip),%rcx        # 635050 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  1837a8:	4c 8d 05 01 17 4b 00 	lea    0x4b1701(%rip),%r8        # 634eb0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xc0>
  1837af:	48 8d 94 24 40 06 00 	lea    0x640(%rsp),%rdx
  1837b6:	00 
  1837b7:	be 2b 00 00 00       	mov    $0x2b,%esi
  1837bc:	ff 15 2e b2 4b 00    	call   *0x4bb22e(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  1837c2:	e9 e6 02 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1837c7:	41 b6 01             	mov    $0x1,%r14b
  1837ca:	48 8d 3d 07 17 4b 00 	lea    0x4b1707(%rip),%rdi        # 634ed8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xe8>
  1837d1:	ff 15 51 b1 4b 00    	call   *0x4bb151(%rip)        # 63e928 <_DYNAMIC+0x298>
  1837d7:	e9 d1 02 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1837dc:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  1837e3:	00 
  1837e4:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  1837eb:	00 
  1837ec:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  1837f3:	00 
  1837f4:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  1837fb:	00 
  1837fc:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  183801:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  183806:	0f 10 94 24 88 00 00 	movups 0x88(%rsp),%xmm2
  18380d:	00 
  18380e:	0f 10 9c 24 98 00 00 	movups 0x98(%rsp),%xmm3
  183815:	00 
  183816:	0f 29 9c 24 60 01 00 	movaps %xmm3,0x160(%rsp)
  18381d:	00 
  18381e:	0f 29 94 24 50 01 00 	movaps %xmm2,0x150(%rsp)
  183825:	00 
  183826:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
  18382d:	00 
  18382e:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  183835:	00 
  183836:	48 8d 3d 3c 12 ef ff 	lea    -0x10edc4(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  18383d:	48 8d 0d 0c 18 4b 00 	lea    0x4b180c(%rip),%rcx        # 635050 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  183844:	4c 8d 05 a5 16 4b 00 	lea    0x4b16a5(%rip),%r8        # 634ef0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x100>
  18384b:	48 8d 94 24 30 01 00 	lea    0x130(%rsp),%rdx
  183852:	00 
  183853:	be 2b 00 00 00       	mov    $0x2b,%esi
  183858:	ff 15 92 b1 4b 00    	call   *0x4bb192(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  18385e:	e9 4a 02 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183863:	48 8d 3d b2 11 ef ff 	lea    -0x10ee4e(%rip),%rdi        # 74a1c <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x133>
  18386a:	48 8d 15 27 17 4b 00 	lea    0x4b1727(%rip),%rdx        # 634f98 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1a8>
  183871:	be 24 00 00 00       	mov    $0x24,%esi
  183876:	ff 15 a4 b0 4b 00    	call   *0x4bb0a4(%rip)        # 63e920 <_DYNAMIC+0x290>
  18387c:	e9 2c 02 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183881:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
  183888:	00 
  183889:	48 8d 15 28 08 ef ff 	lea    -0x10f7d8(%rip),%rdx        # 740b8 <anon.9998a55615a8137a2cfe9ee866adbbd7.127.llvm.17794613580855356888+0x8>
  183890:	4c 8d 0d e9 16 4b 00 	lea    0x4b16e9(%rip),%r9        # 634f80 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x190>
  183897:	31 ff                	xor    %edi,%edi
  183899:	31 c9                	xor    %ecx,%ecx
  18389b:	ff 15 3f b6 4b 00    	call   *0x4bb63f(%rip)        # 63eee0 <_DYNAMIC+0x850>
  1838a1:	e9 07 02 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1838a6:	4c 8d 0d 73 16 4b 00 	lea    0x4b1673(%rip),%r9        # 634f20 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x130>
  1838ad:	48 8d b4 24 c0 01 00 	lea    0x1c0(%rsp),%rsi
  1838b4:	00 
  1838b5:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  1838ba:	31 ff                	xor    %edi,%edi
  1838bc:	31 c9                	xor    %ecx,%ecx
  1838be:	ff 15 14 b6 4b 00    	call   *0x4bb614(%rip)        # 63eed8 <_DYNAMIC+0x848>
  1838c4:	e9 e4 01 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1838c9:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  1838ce:	48 8d 3d a4 11 ef ff 	lea    -0x10ee5c(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1838d5:	48 8d 0d 54 17 4b 00 	lea    0x4b1754(%rip),%rcx        # 635030 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  1838dc:	4c 8d 05 55 16 4b 00 	lea    0x4b1655(%rip),%r8        # 634f38 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x148>
  1838e3:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  1838e8:	be 2b 00 00 00       	mov    $0x2b,%esi
  1838ed:	ff 15 fd b0 4b 00    	call   *0x4bb0fd(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  1838f3:	e9 b5 01 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1838f8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  1838fd:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  183902:	48 8d 3d 70 11 ef ff 	lea    -0x10ee90(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  183909:	48 8d 0d 60 17 4b 00 	lea    0x4b1760(%rip),%rcx        # 635070 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  183910:	4c 8d 05 51 16 4b 00 	lea    0x4b1651(%rip),%r8        # 634f68 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x178>
  183917:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  18391c:	be 2b 00 00 00       	mov    $0x2b,%esi
  183921:	ff 15 c9 b0 4b 00    	call   *0x4bb0c9(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  183927:	e9 81 01 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  18392c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  183931:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  183936:	48 8d 3d 3c 11 ef ff 	lea    -0x10eec4(%rip),%rdi        # 74a79 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  18393d:	48 8d 0d 2c 17 4b 00 	lea    0x4b172c(%rip),%rcx        # 635070 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  183944:	4c 8d 05 1d 16 4b 00 	lea    0x4b161d(%rip),%r8        # 634f68 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x178>
  18394b:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  183950:	be 2b 00 00 00       	mov    $0x2b,%esi
  183955:	ff 15 95 b0 4b 00    	call   *0x4bb095(%rip)        # 63e9f0 <_DYNAMIC+0x360>
  18395b:	e9 4d 01 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183960:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  183965:	b9 01 00 00 00       	mov    $0x1,%ecx
  18396a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  183970:	48 89 ee             	mov    %rbp,%rsi
  183973:	48 89 da             	mov    %rbx,%rdx
  183976:	e8 c5 3b 00 00       	call   187540 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  18397b:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  183980:	e9 bb ef ff ff       	jmp    182940 <allocation_pmu_probe::main+0xb40>
  183985:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  18398a:	ba 01 00 00 00       	mov    $0x1,%edx
  18398f:	b9 01 00 00 00       	mov    $0x1,%ecx
  183994:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  18399a:	e8 a1 3b 00 00       	call   187540 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  18399f:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  1839a4:	e9 d0 ef ff ff       	jmp    182979 <allocation_pmu_probe::main+0xb79>
  1839a9:	48 8d 3d a0 09 4b 00 	lea    0x4b09a0(%rip),%rdi        # 634350 <anon.a0b181daf0748f92ee2071baa91061bb.7.llvm.16326187416535719487>
  1839b0:	ff 15 72 af 4b 00    	call   *0x4baf72(%rip)        # 63e928 <_DYNAMIC+0x298>
  1839b6:	e9 f2 00 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  1839bb:	ba 01 00 00 00       	mov    $0x1,%edx
  1839c0:	b9 01 00 00 00       	mov    $0x1,%ecx
  1839c5:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  1839cb:	48 89 df             	mov    %rbx,%rdi
  1839ce:	e8 6d 3b 00 00       	call   187540 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  1839d3:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  1839d7:	e9 36 f2 ff ff       	jmp    182c12 <allocation_pmu_probe::main+0xe12>
  1839dc:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  1839e1:	ba 01 00 00 00       	mov    $0x1,%edx
  1839e6:	b9 01 00 00 00       	mov    $0x1,%ecx
  1839eb:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  1839f1:	e8 4a 3b 00 00       	call   187540 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  1839f6:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  1839fb:	e9 9c ef ff ff       	jmp    18299c <allocation_pmu_probe::main+0xb9c>
  183a00:	b0 01                	mov    $0x1,%al
  183a02:	e9 27 fb ff ff       	jmp    18352e <allocation_pmu_probe::main+0x172e>
  183a07:	b0 01                	mov    $0x1,%al
  183a09:	e9 3a fb ff ff       	jmp    183548 <allocation_pmu_probe::main+0x1748>
  183a0e:	bf 01 00 00 00       	mov    $0x1,%edi
  183a13:	4c 89 fe             	mov    %r15,%rsi
  183a16:	ff 15 5c af 4b 00    	call   *0x4baf5c(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  183a1c:	e9 8c 00 00 00       	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a21:	48 8d 3d 58 09 4b 00 	lea    0x4b0958(%rip),%rdi        # 634380 <anon.a0b181daf0748f92ee2071baa91061bb.9.llvm.16326187416535719487>
  183a28:	ff 15 fa ae 4b 00    	call   *0x4baefa(%rip)        # 63e928 <_DYNAMIC+0x298>
  183a2e:	eb 7d                	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a30:	48 8d 3d 6a 0f ef ff 	lea    -0x10f096(%rip),%rdi        # 749a1 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xb8>
  183a37:	48 8d 15 fa 13 4b 00 	lea    0x4b13fa(%rip),%rdx        # 634e38 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x48>
  183a3e:	be 34 00 00 00       	mov    $0x34,%esi
  183a43:	ff 15 d7 ae 4b 00    	call   *0x4baed7(%rip)        # 63e920 <_DYNAMIC+0x290>
  183a49:	eb 62                	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a4b:	bf 01 00 00 00       	mov    $0x1,%edi
  183a50:	be 03 00 00 00       	mov    $0x3,%esi
  183a55:	ff 15 1d af 4b 00    	call   *0x4baf1d(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  183a5b:	eb 50                	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a5d:	bf 01 00 00 00       	mov    $0x1,%edi
  183a62:	be 06 00 00 00       	mov    $0x6,%esi
  183a67:	ff 15 0b af 4b 00    	call   *0x4baf0b(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  183a6d:	eb 3e                	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a6f:	bf 01 00 00 00       	mov    $0x1,%edi
  183a74:	4c 89 f6             	mov    %r14,%rsi
  183a77:	ff 15 fb ae 4b 00    	call   *0x4baefb(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  183a7d:	eb 2e                	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a7f:	bf 01 00 00 00       	mov    $0x1,%edi
  183a84:	be 0e 00 00 00       	mov    $0xe,%esi
  183a89:	ff 15 e9 ae 4b 00    	call   *0x4baee9(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  183a8f:	eb 1c                	jmp    183aad <allocation_pmu_probe::main+0x1cad>
  183a91:	31 c0                	xor    %eax,%eax
  183a93:	e9 96 fa ff ff       	jmp    18352e <allocation_pmu_probe::main+0x172e>
  183a98:	31 c0                	xor    %eax,%eax
  183a9a:	e9 a9 fa ff ff       	jmp    183548 <allocation_pmu_probe::main+0x1748>
  183a9f:	bf 01 00 00 00       	mov    $0x1,%edi
  183aa4:	4c 89 f6             	mov    %r14,%rsi
  183aa7:	ff 15 cb ae 4b 00    	call   *0x4baecb(%rip)        # 63e978 <_DYNAMIC+0x2e8>
  183aad:	0f 0b                	ud2
  183aaf:	48 89 c3             	mov    %rax,%rbx
  183ab2:	e9 d5 02 00 00       	jmp    183d8c <allocation_pmu_probe::main+0x1f8c>
  183ab7:	e9 c4 00 00 00       	jmp    183b80 <allocation_pmu_probe::main+0x1d80>
  183abc:	48 89 c3             	mov    %rax,%rbx
  183abf:	e9 15 03 00 00       	jmp    183dd9 <allocation_pmu_probe::main+0x1fd9>
  183ac4:	48 89 c3             	mov    %rax,%rbx
  183ac7:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183acc:	e8 ff d8 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183ad1:	e9 9c 02 00 00       	jmp    183d72 <allocation_pmu_probe::main+0x1f72>
  183ad6:	e9 41 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183adb:	e9 3c 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183ae0:	e9 37 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183ae5:	e9 32 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183aea:	e9 2d 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183aef:	48 89 c3             	mov    %rax,%rbx
  183af2:	e9 51 01 00 00       	jmp    183c48 <allocation_pmu_probe::main+0x1e48>
  183af7:	e9 20 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183afc:	48 89 c3             	mov    %rax,%rbx
  183aff:	e9 5e 01 00 00       	jmp    183c62 <allocation_pmu_probe::main+0x1e62>
  183b04:	e9 13 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183b09:	48 89 c3             	mov    %rax,%rbx
  183b0c:	be 0b 00 00 00       	mov    $0xb,%esi
  183b11:	e9 51 01 00 00       	jmp    183c67 <allocation_pmu_probe::main+0x1e67>
  183b16:	e9 01 01 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183b1b:	48 89 c3             	mov    %rax,%rbx
  183b1e:	be 04 00 00 00       	mov    $0x4,%esi
  183b23:	e9 3f 01 00 00       	jmp    183c67 <allocation_pmu_probe::main+0x1e67>
  183b28:	e9 ef 00 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183b2d:	e9 ea 00 00 00       	jmp    183c1c <allocation_pmu_probe::main+0x1e1c>
  183b32:	48 89 c3             	mov    %rax,%rbx
  183b35:	e9 5f 02 00 00       	jmp    183d99 <allocation_pmu_probe::main+0x1f99>
  183b3a:	48 89 c3             	mov    %rax,%rbx
  183b3d:	eb 0d                	jmp    183b4c <allocation_pmu_probe::main+0x1d4c>
  183b3f:	48 89 c3             	mov    %rax,%rbx
  183b42:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183b47:	e8 84 d8 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183b4c:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  183b51:	e8 ea 0b fd ff       	call   154740 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  183b56:	45 31 f6             	xor    %r14d,%r14d
  183b59:	e9 50 02 00 00       	jmp    183dae <allocation_pmu_probe::main+0x1fae>
  183b5e:	48 89 c3             	mov    %rax,%rbx
  183b61:	e9 64 01 00 00       	jmp    183cca <allocation_pmu_probe::main+0x1eca>
  183b66:	eb 6f                	jmp    183bd7 <allocation_pmu_probe::main+0x1dd7>
  183b68:	48 89 c3             	mov    %rax,%rbx
  183b6b:	be 03 00 00 00       	mov    $0x3,%esi
  183b70:	ba 01 00 00 00       	mov    $0x1,%edx
  183b75:	4c 89 f7             	mov    %r14,%rdi
  183b78:	ff 15 82 ad 4b 00    	call   *0x4bad82(%rip)        # 63e900 <_DYNAMIC+0x270>
  183b7e:	eb 5a                	jmp    183bda <allocation_pmu_probe::main+0x1dda>
  183b80:	48 89 c3             	mov    %rax,%rbx
  183b83:	e9 5e 02 00 00       	jmp    183de6 <allocation_pmu_probe::main+0x1fe6>
  183b88:	48 89 c3             	mov    %rax,%rbx
  183b8b:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183b92:	00 
  183b93:	e8 e8 cb ff ff       	call   180780 <core::ptr::drop_glue::<behavior_store::memory::InMemoryBackend>>
  183b98:	e9 49 02 00 00       	jmp    183de6 <allocation_pmu_probe::main+0x1fe6>
  183b9d:	48 89 c3             	mov    %rax,%rbx
  183ba0:	4d 85 f6             	test   %r14,%r14
  183ba3:	0f 84 57 02 00 00    	je     183e00 <allocation_pmu_probe::main+0x2000>
  183ba9:	4c 89 e7             	mov    %r12,%rdi
  183bac:	4c 89 f6             	mov    %r14,%rsi
  183baf:	ba 01 00 00 00       	mov    $0x1,%edx
  183bb4:	ff 15 46 ad 4b 00    	call   *0x4bad46(%rip)        # 63e900 <_DYNAMIC+0x270>
  183bba:	e9 41 02 00 00       	jmp    183e00 <allocation_pmu_probe::main+0x2000>
  183bbf:	48 89 c3             	mov    %rax,%rbx
  183bc2:	e9 39 02 00 00       	jmp    183e00 <allocation_pmu_probe::main+0x2000>
  183bc7:	48 89 c3             	mov    %rax,%rbx
  183bca:	e9 51 02 00 00       	jmp    183e20 <allocation_pmu_probe::main+0x2020>
  183bcf:	48 89 c3             	mov    %rax,%rbx
  183bd2:	e9 59 01 00 00       	jmp    183d30 <allocation_pmu_probe::main+0x1f30>
  183bd7:	48 89 c3             	mov    %rax,%rbx
  183bda:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  183bdf:	e8 ec 14 fd ff       	call   1550d0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value> as core::ops::drop::Drop>::drop>
  183be4:	e9 f8 00 00 00       	jmp    183ce1 <allocation_pmu_probe::main+0x1ee1>
  183be9:	48 89 c3             	mov    %rax,%rbx
  183bec:	49 8d 46 ff          	lea    -0x1(%r14),%rax
  183bf0:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  183bf4:	0f 87 92 01 00 00    	ja     183d8c <allocation_pmu_probe::main+0x1f8c>
  183bfa:	4c 89 f6             	mov    %r14,%rsi
  183bfd:	ba 01 00 00 00       	mov    $0x1,%edx
  183c02:	4c 89 e7             	mov    %r12,%rdi
  183c05:	e9 7c 01 00 00       	jmp    183d86 <allocation_pmu_probe::main+0x1f86>
  183c0a:	48 89 c3             	mov    %rax,%rbx
  183c0d:	e9 e1 01 00 00       	jmp    183df3 <allocation_pmu_probe::main+0x1ff3>
  183c12:	e9 58 01 00 00       	jmp    183d6f <allocation_pmu_probe::main+0x1f6f>
  183c17:	e9 53 01 00 00       	jmp    183d6f <allocation_pmu_probe::main+0x1f6f>
  183c1c:	48 89 c3             	mov    %rax,%rbx
  183c1f:	eb 54                	jmp    183c75 <allocation_pmu_probe::main+0x1e75>
  183c21:	48 89 c3             	mov    %rax,%rbx
  183c24:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183c29:	e8 02 d7 ff ff       	call   181330 <core::ptr::drop_glue::<serde_json::error::Error>>
  183c2e:	e9 3f 01 00 00       	jmp    183d72 <allocation_pmu_probe::main+0x1f72>
  183c33:	ff 15 f7 ac 4b 00    	call   *0x4bacf7(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183c39:	0f 0b                	ud2
  183c3b:	48 89 c3             	mov    %rax,%rbx
  183c3e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  183c43:	e8 e8 d6 ff ff       	call   181330 <core::ptr::drop_glue::<serde_json::error::Error>>
  183c48:	be 08 00 00 00       	mov    $0x8,%esi
  183c4d:	eb 18                	jmp    183c67 <allocation_pmu_probe::main+0x1e67>
  183c4f:	ff 15 db ac 4b 00    	call   *0x4bacdb(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183c55:	48 89 c3             	mov    %rax,%rbx
  183c58:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  183c5d:	e8 ce d6 ff ff       	call   181330 <core::ptr::drop_glue::<serde_json::error::Error>>
  183c62:	be 09 00 00 00       	mov    $0x9,%esi
  183c67:	ba 01 00 00 00       	mov    $0x1,%edx
  183c6c:	4c 89 ef             	mov    %r13,%rdi
  183c6f:	ff 15 8b ac 4b 00    	call   *0x4bac8b(%rip)        # 63e900 <_DYNAMIC+0x270>
  183c75:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  183c7c:	00 
  183c7d:	e8 4e 14 fd ff       	call   1550d0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value> as core::ops::drop::Drop>::drop>
  183c82:	e9 eb 00 00 00       	jmp    183d72 <allocation_pmu_probe::main+0x1f72>
  183c87:	ff 15 a3 ac 4b 00    	call   *0x4baca3(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183c8d:	48 89 c3             	mov    %rax,%rbx
  183c90:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183c95:	e8 36 d8 ff ff       	call   1814d0 <core::ptr::drop_glue::<core::io::error::Error>>
  183c9a:	e9 d3 00 00 00       	jmp    183d72 <allocation_pmu_probe::main+0x1f72>
  183c9f:	ff 15 8b ac 4b 00    	call   *0x4bac8b(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183ca5:	48 89 c3             	mov    %rax,%rbx
  183ca8:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  183caf:	00 
  183cb0:	e8 2b cf ff ff       	call   180be0 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  183cb5:	e9 df 00 00 00       	jmp    183d99 <allocation_pmu_probe::main+0x1f99>
  183cba:	48 89 c3             	mov    %rax,%rbx
  183cbd:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  183cc4:	00 
  183cc5:	e8 16 cf ff ff       	call   180be0 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  183cca:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  183cd1:	00 
  183cd2:	e8 f9 d6 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183cd7:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183cdc:	e8 ef d6 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183ce1:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  183ce6:	e8 55 0a fd ff       	call   154740 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  183ceb:	e9 e9 00 00 00       	jmp    183dd9 <allocation_pmu_probe::main+0x1fd9>
  183cf0:	48 89 c3             	mov    %rax,%rbx
  183cf3:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183cfa:	00 
  183cfb:	e8 e0 ce ff ff       	call   180be0 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  183d00:	e9 e1 00 00 00       	jmp    183de6 <allocation_pmu_probe::main+0x1fe6>
  183d05:	48 89 c3             	mov    %rax,%rbx
  183d08:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183d0f:	00 
  183d10:	e8 bb d7 ff ff       	call   1814d0 <core::ptr::drop_glue::<core::io::error::Error>>
  183d15:	e9 06 01 00 00       	jmp    183e20 <allocation_pmu_probe::main+0x2020>
  183d1a:	ff 15 10 ac 4b 00    	call   *0x4bac10(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183d20:	48 89 c3             	mov    %rax,%rbx
  183d23:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  183d2a:	00 
  183d2b:	e8 a0 d7 ff ff       	call   1814d0 <core::ptr::drop_glue::<core::io::error::Error>>
  183d30:	41 bc 07 00 00 00    	mov    $0x7,%r12d
  183d36:	e9 f7 00 00 00       	jmp    183e32 <allocation_pmu_probe::main+0x2032>
  183d3b:	ff 15 ef ab 4b 00    	call   *0x4babef(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183d41:	48 89 c3             	mov    %rax,%rbx
  183d44:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  183d4b:	00 
  183d4c:	e8 7f d7 ff ff       	call   1814d0 <core::ptr::drop_glue::<core::io::error::Error>>
  183d51:	41 bc 07 00 00 00    	mov    $0x7,%r12d
  183d57:	4c 8b b4 24 00 01 00 	mov    0x100(%rsp),%r14
  183d5e:	00 
  183d5f:	e9 1b 01 00 00       	jmp    183e7f <allocation_pmu_probe::main+0x207f>
  183d64:	ff 15 c6 ab 4b 00    	call   *0x4babc6(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183d6a:	48 89 c3             	mov    %rax,%rbx
  183d6d:	eb 1d                	jmp    183d8c <allocation_pmu_probe::main+0x1f8c>
  183d6f:	48 89 c3             	mov    %rax,%rbx
  183d72:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  183d77:	48 85 f6             	test   %rsi,%rsi
  183d7a:	74 10                	je     183d8c <allocation_pmu_probe::main+0x1f8c>
  183d7c:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  183d81:	ba 01 00 00 00       	mov    $0x1,%edx
  183d86:	ff 15 74 ab 4b 00    	call   *0x4bab74(%rip)        # 63e900 <_DYNAMIC+0x270>
  183d8c:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  183d93:	00 
  183d94:	e8 a7 c9 ff ff       	call   180740 <core::ptr::drop_glue::<behavior_store::store::Committed>>
  183d99:	41 b6 01             	mov    $0x1,%r14b
  183d9c:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  183da3:	00 
  183da4:	e8 a7 d0 ff ff       	call   180e50 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  183da9:	eb 03                	jmp    183dae <allocation_pmu_probe::main+0x1fae>
  183dab:	48 89 c3             	mov    %rax,%rbx
  183dae:	48 8d bc 24 78 08 00 	lea    0x878(%rsp),%rdi
  183db5:	00 
  183db6:	e8 15 d6 ff ff       	call   1813d0 <core::ptr::drop_glue::<serde_json::value::Value>>
  183dbb:	48 83 bc 24 40 06 00 	cmpq   $0xffffffffffffffff,0x640(%rsp)
  183dc2:	00 ff 
  183dc4:	0f 94 c0             	sete   %al
  183dc7:	41 08 c6             	or     %al,%r14b
  183dca:	75 0d                	jne    183dd9 <allocation_pmu_probe::main+0x1fd9>
  183dcc:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  183dd3:	00 
  183dd4:	e8 77 d0 ff ff       	call   180e50 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  183dd9:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183de0:	00 
  183de1:	e8 4a c5 ff ff       	call   180330 <core::ptr::drop_glue::<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>>
  183de6:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  183ded:	00 
  183dee:	e8 1d d7 ff ff       	call   181510 <core::ptr::drop_glue::<behavior_core::semantic::module::Module>>
  183df3:	48 8d bc 24 e8 01 00 	lea    0x1e8(%rsp),%rdi
  183dfa:	00 
  183dfb:	e8 f0 c8 ff ff       	call   1806f0 <core::ptr::drop_glue::<allocation_pmu_probe::fixture::Case>>
  183e00:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
  183e07:	00 
  183e08:	48 85 f6             	test   %rsi,%rsi
  183e0b:	74 13                	je     183e20 <allocation_pmu_probe::main+0x2020>
  183e0d:	48 8b bc 24 18 01 00 	mov    0x118(%rsp),%rdi
  183e14:	00 
  183e15:	ba 01 00 00 00       	mov    $0x1,%edx
  183e1a:	ff 15 e0 aa 4b 00    	call   *0x4baae0(%rip)        # 63e900 <_DYNAMIC+0x270>
  183e20:	8b 7c 24 64          	mov    0x64(%rsp),%edi
  183e24:	ff 15 a6 b0 4b 00    	call   *0x4bb0a6(%rip)        # 63eed0 <close@GLIBC_2.2.5>
  183e2a:	4c 8b a4 24 08 01 00 	mov    0x108(%rsp),%r12
  183e31:	00 
  183e32:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  183e36:	ff 15 94 b0 4b 00    	call   *0x4bb094(%rip)        # 63eed0 <close@GLIBC_2.2.5>
  183e3c:	eb 09                	jmp    183e47 <allocation_pmu_probe::main+0x2047>
  183e3e:	ff 15 ec aa 4b 00    	call   *0x4baaec(%rip)        # 63e930 <_DYNAMIC+0x2a0>
  183e44:	48 89 c3             	mov    %rax,%rbx
  183e47:	4c 8b b4 24 00 01 00 	mov    0x100(%rsp),%r14
  183e4e:	00 
  183e4f:	4d 85 e4             	test   %r12,%r12
  183e52:	75 2b                	jne    183e7f <allocation_pmu_probe::main+0x207f>
  183e54:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  183e5b:	00 
  183e5c:	48 85 c0             	test   %rax,%rax
  183e5f:	74 16                	je     183e77 <allocation_pmu_probe::main+0x2077>
  183e61:	48 c1 e0 03          	shl    $0x3,%rax
  183e65:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  183e69:	ba 08 00 00 00       	mov    $0x8,%edx
  183e6e:	4c 89 f7             	mov    %r14,%rdi
  183e71:	ff 15 89 aa 4b 00    	call   *0x4baa89(%rip)        # 63e900 <_DYNAMIC+0x270>
  183e77:	48 89 df             	mov    %rbx,%rdi
  183e7a:	e8 c1 f0 4a 00       	call   632f40 <_Unwind_Resume@plt>
  183e7f:	4d 8d 7e 08          	lea    0x8(%r14),%r15
  183e83:	4c 8b 2d 76 aa 4b 00 	mov    0x4baa76(%rip),%r13        # 63e900 <_DYNAMIC+0x270>
  183e8a:	eb 0d                	jmp    183e99 <allocation_pmu_probe::main+0x2099>
  183e8c:	0f 1f 40 00          	nopl   0x0(%rax)
  183e90:	49 83 c7 18          	add    $0x18,%r15
  183e94:	49 ff cc             	dec    %r12
  183e97:	74 bb                	je     183e54 <allocation_pmu_probe::main+0x2054>
  183e99:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  183e9d:	48 85 f6             	test   %rsi,%rsi
  183ea0:	74 ee                	je     183e90 <allocation_pmu_probe::main+0x2090>
  183ea2:	49 8b 3f             	mov    (%r15),%rdi
  183ea5:	ba 01 00 00 00       	mov    $0x1,%edx
  183eaa:	41 ff d5             	call   *%r13
  183ead:	eb e1                	jmp    183e90 <allocation_pmu_probe::main+0x2090>
  183eaf:	cc                   	int3
