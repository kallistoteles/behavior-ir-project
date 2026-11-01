
/tmp/core-final-pmu-binaries-20261101/exec03:     file format elf64-x86-64


Disassembly of section .text:

0000000000183c70 <allocation_pmu_probe::main>:
  183c70:	55                   	push   %rbp
  183c71:	41 57                	push   %r15
  183c73:	41 56                	push   %r14
  183c75:	41 55                	push   %r13
  183c77:	41 54                	push   %r12
  183c79:	53                   	push   %rbx
  183c7a:	48 81 ec 18 0e 00 00 	sub    $0xe18,%rsp
  183c81:	48 8d 9c 24 78 02 00 	lea    0x278(%rsp),%rbx
  183c88:	00 
  183c89:	48 89 df             	mov    %rbx,%rdi
  183c8c:	ff 15 e6 39 4c 00    	call   *0x4c39e6(%rip)        # 647678 <_DYNAMIC+0x818>
  183c92:	48 c7 84 24 98 02 00 	movq   $0x1,0x298(%rsp)
  183c99:	00 01 00 00 00 
  183c9e:	48 8d bc 24 f8 00 00 	lea    0xf8(%rsp),%rdi
  183ca5:	00 
  183ca6:	48 89 de             	mov    %rbx,%rsi
  183ca9:	e8 72 89 fe ff       	call   16c620 <<alloc::vec::Vec<alloc::string::String> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<alloc::string::String, core::iter::adapters::skip::Skip<std::env::Args>>>::from_iter>
  183cae:	4c 8b a4 24 08 01 00 	mov    0x108(%rsp),%r12
  183cb5:	00 
  183cb6:	4c 89 a4 24 78 02 00 	mov    %r12,0x278(%rsp)
  183cbd:	00 
  183cbe:	49 83 fc 07          	cmp    $0x7,%r12
  183cc2:	0f 85 6e 17 00 00    	jne    185436 <allocation_pmu_probe::main+0x17c6>
  183cc8:	4c 8b bc 24 00 01 00 	mov    0x100(%rsp),%r15
  183ccf:	00 
  183cd0:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  183cd4:	49 8b 77 10          	mov    0x10(%r15),%rsi
  183cd8:	48 83 fe 01          	cmp    $0x1,%rsi
  183cdc:	74 0e                	je     183cec <allocation_pmu_probe::main+0x7c>
  183cde:	48 85 f6             	test   %rsi,%rsi
  183ce1:	0f 84 1a 1c 00 00    	je     185901 <allocation_pmu_probe::main+0x1c91>
  183ce7:	0f b6 11             	movzbl (%rcx),%edx
  183cea:	eb 17                	jmp    183d03 <allocation_pmu_probe::main+0x93>
  183cec:	0f b6 11             	movzbl (%rcx),%edx
  183cef:	b0 01                	mov    $0x1,%al
  183cf1:	83 fa 2b             	cmp    $0x2b,%edx
  183cf4:	0f 84 a4 16 00 00    	je     18539e <allocation_pmu_probe::main+0x172e>
  183cfa:	83 fa 2d             	cmp    $0x2d,%edx
  183cfd:	0f 84 9b 16 00 00    	je     18539e <allocation_pmu_probe::main+0x172e>
  183d03:	31 c0                	xor    %eax,%eax
  183d05:	80 fa 2b             	cmp    $0x2b,%dl
  183d08:	0f 94 c0             	sete   %al
  183d0b:	48 89 f2             	mov    %rsi,%rdx
  183d0e:	48 29 c2             	sub    %rax,%rdx
  183d11:	48 01 c1             	add    %rax,%rcx
  183d14:	48 f7 d8             	neg    %rax
  183d17:	48 83 fa 11          	cmp    $0x11,%rdx
  183d1b:	73 3a                	jae    183d57 <allocation_pmu_probe::main+0xe7>
  183d1d:	48 85 d2             	test   %rdx,%rdx
  183d20:	0f 84 7d 00 00 00    	je     183da3 <allocation_pmu_probe::main+0x133>
  183d26:	48 01 c6             	add    %rax,%rsi
  183d29:	48 f7 de             	neg    %rsi
  183d2c:	31 c0                	xor    %eax,%eax
  183d2e:	31 d2                	xor    %edx,%edx
  183d30:	0f b6 3c 11          	movzbl (%rcx,%rdx,1),%edi
  183d34:	83 c7 d0             	add    $0xffffffd0,%edi
  183d37:	83 ff 09             	cmp    $0x9,%edi
  183d3a:	0f 87 30 1b 00 00    	ja     185870 <allocation_pmu_probe::main+0x1c00>
  183d40:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  183d44:	89 ff                	mov    %edi,%edi
  183d46:	48 8d 04 47          	lea    (%rdi,%rax,2),%rax
  183d4a:	48 ff c2             	inc    %rdx
  183d4d:	48 89 f7             	mov    %rsi,%rdi
  183d50:	48 01 d7             	add    %rdx,%rdi
  183d53:	75 db                	jne    183d30 <allocation_pmu_probe::main+0xc0>
  183d55:	eb 4e                	jmp    183da5 <allocation_pmu_probe::main+0x135>
  183d57:	48 01 c6             	add    %rax,%rsi
  183d5a:	48 f7 de             	neg    %rsi
  183d5d:	31 c0                	xor    %eax,%eax
  183d5f:	bf 0a 00 00 00       	mov    $0xa,%edi
  183d64:	45 31 c0             	xor    %r8d,%r8d
  183d67:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  183d6e:	00 00 
  183d70:	48 89 f2             	mov    %rsi,%rdx
  183d73:	4c 01 c2             	add    %r8,%rdx
  183d76:	74 2d                	je     183da5 <allocation_pmu_probe::main+0x135>
  183d78:	48 f7 e7             	mul    %rdi
  183d7b:	42 0f b6 14 01       	movzbl (%rcx,%r8,1),%edx
  183d80:	0f 80 0e 16 00 00    	jo     185394 <allocation_pmu_probe::main+0x1724>
  183d86:	83 c2 d0             	add    $0xffffffd0,%edx
  183d89:	83 fa 0a             	cmp    $0xa,%edx
  183d8c:	0f 83 de 1a 00 00    	jae    185870 <allocation_pmu_probe::main+0x1c00>
  183d92:	89 d2                	mov    %edx,%edx
  183d94:	49 ff c0             	inc    %r8
  183d97:	48 01 d0             	add    %rdx,%rax
  183d9a:	73 d4                	jae    183d70 <allocation_pmu_probe::main+0x100>
  183d9c:	b0 02                	mov    $0x2,%al
  183d9e:	e9 fb 15 00 00       	jmp    18539e <allocation_pmu_probe::main+0x172e>
  183da3:	31 c0                	xor    %eax,%eax
  183da5:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  183dac:	00 
  183dad:	49 8b 4f 20          	mov    0x20(%r15),%rcx
  183db1:	49 8b 77 28          	mov    0x28(%r15),%rsi
  183db5:	48 83 fe 01          	cmp    $0x1,%rsi
  183db9:	74 0e                	je     183dc9 <allocation_pmu_probe::main+0x159>
  183dbb:	48 85 f6             	test   %rsi,%rsi
  183dbe:	0f 84 44 1b 00 00    	je     185908 <allocation_pmu_probe::main+0x1c98>
  183dc4:	0f b6 11             	movzbl (%rcx),%edx
  183dc7:	eb 17                	jmp    183de0 <allocation_pmu_probe::main+0x170>
  183dc9:	0f b6 11             	movzbl (%rcx),%edx
  183dcc:	b0 01                	mov    $0x1,%al
  183dce:	83 fa 2b             	cmp    $0x2b,%edx
  183dd1:	0f 84 e1 15 00 00    	je     1853b8 <allocation_pmu_probe::main+0x1748>
  183dd7:	83 fa 2d             	cmp    $0x2d,%edx
  183dda:	0f 84 d8 15 00 00    	je     1853b8 <allocation_pmu_probe::main+0x1748>
  183de0:	31 c0                	xor    %eax,%eax
  183de2:	80 fa 2b             	cmp    $0x2b,%dl
  183de5:	0f 94 c0             	sete   %al
  183de8:	48 89 f2             	mov    %rsi,%rdx
  183deb:	48 29 c2             	sub    %rax,%rdx
  183dee:	48 01 c1             	add    %rax,%rcx
  183df1:	48 f7 d8             	neg    %rax
  183df4:	48 83 fa 11          	cmp    $0x11,%rdx
  183df8:	73 44                	jae    183e3e <allocation_pmu_probe::main+0x1ce>
  183dfa:	48 85 d2             	test   %rdx,%rdx
  183dfd:	0f 84 86 00 00 00    	je     183e89 <allocation_pmu_probe::main+0x219>
  183e03:	48 01 c6             	add    %rax,%rsi
  183e06:	48 f7 de             	neg    %rsi
  183e09:	45 31 ed             	xor    %r13d,%r13d
  183e0c:	31 c0                	xor    %eax,%eax
  183e0e:	66 90                	xchg   %ax,%ax
  183e10:	0f b6 14 01          	movzbl (%rcx,%rax,1),%edx
  183e14:	83 c2 d0             	add    $0xffffffd0,%edx
  183e17:	83 fa 09             	cmp    $0x9,%edx
  183e1a:	0f 87 57 1a 00 00    	ja     185877 <allocation_pmu_probe::main+0x1c07>
  183e20:	4a 8d 3c ad 00 00 00 	lea    0x0(,%r13,4),%rdi
  183e27:	00 
  183e28:	4c 01 ef             	add    %r13,%rdi
  183e2b:	89 d2                	mov    %edx,%edx
  183e2d:	4c 8d 2c 7a          	lea    (%rdx,%rdi,2),%r13
  183e31:	48 ff c0             	inc    %rax
  183e34:	48 89 f2             	mov    %rsi,%rdx
  183e37:	48 01 c2             	add    %rax,%rdx
  183e3a:	75 d4                	jne    183e10 <allocation_pmu_probe::main+0x1a0>
  183e3c:	eb 4e                	jmp    183e8c <allocation_pmu_probe::main+0x21c>
  183e3e:	48 01 c6             	add    %rax,%rsi
  183e41:	48 f7 de             	neg    %rsi
  183e44:	45 31 ed             	xor    %r13d,%r13d
  183e47:	bf 0a 00 00 00       	mov    $0xa,%edi
  183e4c:	45 31 c0             	xor    %r8d,%r8d
  183e4f:	90                   	nop
  183e50:	48 89 f0             	mov    %rsi,%rax
  183e53:	4c 01 c0             	add    %r8,%rax
  183e56:	74 34                	je     183e8c <allocation_pmu_probe::main+0x21c>
  183e58:	4c 89 e8             	mov    %r13,%rax
  183e5b:	48 f7 e7             	mul    %rdi
  183e5e:	42 0f b6 14 01       	movzbl (%rcx,%r8,1),%edx
  183e63:	0f 80 45 15 00 00    	jo     1853ae <allocation_pmu_probe::main+0x173e>
  183e69:	83 c2 d0             	add    $0xffffffd0,%edx
  183e6c:	83 fa 0a             	cmp    $0xa,%edx
  183e6f:	0f 83 02 1a 00 00    	jae    185877 <allocation_pmu_probe::main+0x1c07>
  183e75:	49 89 c5             	mov    %rax,%r13
  183e78:	89 d0                	mov    %edx,%eax
  183e7a:	49 ff c0             	inc    %r8
  183e7d:	49 01 c5             	add    %rax,%r13
  183e80:	73 ce                	jae    183e50 <allocation_pmu_probe::main+0x1e0>
  183e82:	b0 02                	mov    $0x2,%al
  183e84:	e9 2f 15 00 00       	jmp    1853b8 <allocation_pmu_probe::main+0x1748>
  183e89:	45 31 ed             	xor    %r13d,%r13d
  183e8c:	49 8b 47 40          	mov    0x40(%r15),%rax
  183e90:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  183e97:	00 
  183e98:	48 83 f8 05          	cmp    $0x5,%rax
  183e9c:	0f 85 fe 19 00 00    	jne    1858a0 <allocation_pmu_probe::main+0x1c30>
  183ea2:	49 8b 57 38          	mov    0x38(%r15),%rdx
  183ea6:	b8 61 6c 6c 6f       	mov    $0x6f6c6c61,%eax
  183eab:	33 02                	xor    (%rdx),%eax
  183ead:	0f b6 4a 04          	movzbl 0x4(%rdx),%ecx
  183eb1:	83 f1 63             	xor    $0x63,%ecx
  183eb4:	09 c1                	or     %eax,%ecx
  183eb6:	74 16                	je     183ece <allocation_pmu_probe::main+0x25e>
  183eb8:	b8 65 6d 70 74       	mov    $0x74706d65,%eax
  183ebd:	33 02                	xor    (%rdx),%eax
  183ebf:	0f b6 4a 04          	movzbl 0x4(%rdx),%ecx
  183ec3:	83 f1 79             	xor    $0x79,%ecx
  183ec6:	09 c1                	or     %eax,%ecx
  183ec8:	0f 85 d2 19 00 00    	jne    1858a0 <allocation_pmu_probe::main+0x1c30>
  183ece:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  183ed5:	00 
  183ed6:	48 bb 00 00 00 00 b6 	movabs $0x1b600000000,%rbx
  183edd:	01 00 00 
  183ee0:	48 89 9c 24 78 02 00 	mov    %rbx,0x278(%rsp)
  183ee7:	00 
  183ee8:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
  183eef:	00 00 00 00 
  183ef3:	66 c7 84 24 84 02 00 	movw   $0x0,0x284(%rsp)
  183efa:	00 00 00 
  183efd:	c6 84 24 81 02 00 00 	movb   $0x1,0x281(%rsp)
  183f04:	01 
  183f05:	49 8b 57 50          	mov    0x50(%r15),%rdx
  183f09:	49 8b 4f 58          	mov    0x58(%r15),%rcx
  183f0d:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183f14:	00 
  183f15:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  183f1c:	00 
  183f1d:	ff 15 bd 36 4c 00    	call   *0x4c36bd(%rip)        # 6475e0 <_DYNAMIC+0x780>
  183f23:	83 bc 24 a0 08 00 00 	cmpl   $0x1,0x8a0(%rsp)
  183f2a:	01 
  183f2b:	0f 84 35 15 00 00    	je     185466 <allocation_pmu_probe::main+0x17f6>
  183f31:	8b 84 24 a4 08 00 00 	mov    0x8a4(%rsp),%eax
  183f38:	89 44 24 60          	mov    %eax,0x60(%rsp)
  183f3c:	48 89 9c 24 78 02 00 	mov    %rbx,0x278(%rsp)
  183f43:	00 
  183f44:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
  183f4b:	00 00 00 00 
  183f4f:	66 c7 84 24 84 02 00 	movw   $0x0,0x284(%rsp)
  183f56:	00 00 00 
  183f59:	c6 84 24 80 02 00 00 	movb   $0x1,0x280(%rsp)
  183f60:	01 
  183f61:	49 8b 57 68          	mov    0x68(%r15),%rdx
  183f65:	49 8b 4f 70          	mov    0x70(%r15),%rcx
  183f69:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183f70:	00 
  183f71:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  183f78:	00 
  183f79:	ff 15 61 36 4c 00    	call   *0x4c3661(%rip)        # 6475e0 <_DYNAMIC+0x780>
  183f7f:	83 bc 24 a0 08 00 00 	cmpl   $0x1,0x8a0(%rsp)
  183f86:	01 
  183f87:	0f 84 16 15 00 00    	je     1854a3 <allocation_pmu_probe::main+0x1833>
  183f8d:	8b 84 24 a4 08 00 00 	mov    0x8a4(%rsp),%eax
  183f94:	89 44 24 64          	mov    %eax,0x64(%rsp)
  183f98:	49 8b b7 80 00 00 00 	mov    0x80(%r15),%rsi
  183f9f:	49 8b 97 88 00 00 00 	mov    0x88(%r15),%rdx
  183fa6:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  183fad:	00 
  183fae:	ff 15 34 36 4c 00    	call   *0x4c3634(%rip)        # 6475e8 <_DYNAMIC+0x788>
  183fb4:	48 83 bc 24 78 02 00 	cmpq   $0xffffffffffffffff,0x278(%rsp)
  183fbb:	00 ff 
  183fbd:	0f 84 1d 15 00 00    	je     1854e0 <allocation_pmu_probe::main+0x1870>
  183fc3:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
  183fca:	00 
  183fcb:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  183fd2:	00 
  183fd3:	0f 10 84 24 78 02 00 	movups 0x278(%rsp),%xmm0
  183fda:	00 
  183fdb:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  183fe2:	00 
  183fe3:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  183fea:	00 
  183feb:	48 89 84 24 a0 08 00 	mov    %rax,0x8a0(%rsp)
  183ff2:	00 
  183ff3:	48 8b 05 a6 34 4c 00 	mov    0x4c34a6(%rip),%rax        # 6474a0 <_DYNAMIC+0x640>
  183ffa:	48 89 84 24 a8 08 00 	mov    %rax,0x8a8(%rsp)
  184001:	00 
  184002:	48 8d 35 d1 99 ee ff 	lea    -0x11662f(%rip),%rsi        # 6d9da <anon.51c7706b7d121e0533333fbcddf476a8.59.llvm.9807284637049078916+0xd6>
  184009:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  184010:	00 
  184011:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  184018:	00 
  184019:	ff 15 89 31 4c 00    	call   *0x4c3189(%rip)        # 6471a8 <_DYNAMIC+0x348>
  18401f:	4c 8b b4 24 78 02 00 	mov    0x278(%rsp),%r14
  184026:	00 
  184027:	4c 8b a4 24 80 02 00 	mov    0x280(%rsp),%r12
  18402e:	00 
  18402f:	48 8b 9c 24 88 02 00 	mov    0x288(%rsp),%rbx
  184036:	00 
  184037:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  18403e:	00 
  18403f:	e8 3c 36 fe ff       	call   167680 <<allocation_pmu_probe::fixture::Case as core::default::Default>::default>
  184044:	4c 89 b4 24 b0 01 00 	mov    %r14,0x1b0(%rsp)
  18404b:	00 
  18404c:	4c 89 b4 24 e8 01 00 	mov    %r14,0x1e8(%rsp)
  184053:	00 
  184054:	4c 89 a4 24 98 01 00 	mov    %r12,0x198(%rsp)
  18405b:	00 
  18405c:	4c 89 a4 24 f0 01 00 	mov    %r12,0x1f0(%rsp)
  184063:	00 
  184064:	48 89 9c 24 f8 01 00 	mov    %rbx,0x1f8(%rsp)
  18406b:	00 
  18406c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  184073:	00 
  184074:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  18407b:	00 
  18407c:	0f 10 84 24 c8 02 00 	movups 0x2c8(%rsp),%xmm0
  184083:	00 
  184084:	0f 11 84 24 38 02 00 	movups %xmm0,0x238(%rsp)
  18408b:	00 
  18408c:	0f 10 84 24 d8 02 00 	movups 0x2d8(%rsp),%xmm0
  184093:	00 
  184094:	0f 11 84 24 48 02 00 	movups %xmm0,0x248(%rsp)
  18409b:	00 
  18409c:	0f 10 84 24 e8 02 00 	movups 0x2e8(%rsp),%xmm0
  1840a3:	00 
  1840a4:	0f 11 84 24 58 02 00 	movups %xmm0,0x258(%rsp)
  1840ab:	00 
  1840ac:	0f 10 84 24 90 02 00 	movups 0x290(%rsp),%xmm0
  1840b3:	00 
  1840b4:	0f 11 84 24 00 02 00 	movups %xmm0,0x200(%rsp)
  1840bb:	00 
  1840bc:	48 8b 84 24 a0 02 00 	mov    0x2a0(%rsp),%rax
  1840c3:	00 
  1840c4:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  1840cb:	00 
  1840cc:	0f 10 84 24 a8 02 00 	movups 0x2a8(%rsp),%xmm0
  1840d3:	00 
  1840d4:	0f 11 84 24 18 02 00 	movups %xmm0,0x218(%rsp)
  1840db:	00 
  1840dc:	48 8b 84 24 b8 02 00 	mov    0x2b8(%rsp),%rax
  1840e3:	00 
  1840e4:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  1840eb:	00 
  1840ec:	4c 89 ac 24 68 02 00 	mov    %r13,0x268(%rsp)
  1840f3:	00 
  1840f4:	0f b6 84 24 00 03 00 	movzbl 0x300(%rsp),%eax
  1840fb:	00 
  1840fc:	88 84 24 70 02 00 00 	mov    %al,0x270(%rsp)
  184103:	48 8b b4 24 78 02 00 	mov    0x278(%rsp),%rsi
  18410a:	00 
  18410b:	48 85 f6             	test   %rsi,%rsi
  18410e:	74 13                	je     184123 <allocation_pmu_probe::main+0x4b3>
  184110:	48 8b bc 24 80 02 00 	mov    0x280(%rsp),%rdi
  184117:	00 
  184118:	ba 01 00 00 00       	mov    $0x1,%edx
  18411d:	ff 15 ad 2f 4c 00    	call   *0x4c2fad(%rip)        # 6470d0 <_DYNAMIC+0x270>
  184123:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  18412a:	00 
  18412b:	48 8d b4 24 e8 01 00 	lea    0x1e8(%rsp),%rsi
  184132:	00 
  184133:	e8 18 24 fe ff       	call   166550 <allocation_pmu_probe::fixture::module>
  184138:	48 c7 84 24 b8 08 00 	movq   $0xffffffffffffffff,0x8b8(%rsp)
  18413f:	00 ff ff ff ff 
  184144:	48 c7 84 24 c8 09 00 	movq   $0xffffffffffffffff,0x9c8(%rsp)
  18414b:	00 ff ff ff ff 
  184150:	48 c7 84 24 80 0a 00 	movq   $0x0,0xa80(%rsp)
  184157:	00 00 00 00 00 
  18415c:	0f 57 c0             	xorps  %xmm0,%xmm0
  18415f:	0f 11 84 24 90 0a 00 	movups %xmm0,0xa90(%rsp)
  184166:	00 
  184167:	48 c7 84 24 a0 08 00 	movq   $0x0,0x8a0(%rsp)
  18416e:	00 00 00 00 00 
  184173:	48 c7 84 24 a8 08 00 	movq   $0x8,0x8a8(%rsp)
  18417a:	00 08 00 00 00 
  18417f:	48 c7 84 24 b0 08 00 	movq   $0x0,0x8b0(%rsp)
  184186:	00 00 00 00 00 
  18418b:	48 c7 84 24 f0 0a 00 	movq   $0x0,0xaf0(%rsp)
  184192:	00 00 00 00 00 
  184197:	0f 11 84 24 a8 0a 00 	movups %xmm0,0xaa8(%rsp)
  18419e:	00 
  18419f:	0f 11 84 24 c0 0a 00 	movups %xmm0,0xac0(%rsp)
  1841a6:	00 
  1841a7:	0f 11 84 24 d8 0a 00 	movups %xmm0,0xad8(%rsp)
  1841ae:	00 
  1841af:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  1841b6:	00 
  1841b7:	48 8d b4 24 e8 01 00 	lea    0x1e8(%rsp),%rsi
  1841be:	00 
  1841bf:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  1841c6:	00 
  1841c7:	e8 94 2a fe ff       	call   166c60 <allocation_pmu_probe::fixture::genesis>
  1841cc:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  1841d3:	00 
  1841d4:	48 8d b4 24 a0 08 00 	lea    0x8a0(%rsp),%rsi
  1841db:	00 
  1841dc:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  1841e3:	00 
  1841e4:	48 8d 8c 24 40 06 00 	lea    0x640(%rsp),%rcx
  1841eb:	00 
  1841ec:	e8 0f 66 fb ff       	call   13a800 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::create>
  1841f1:	48 83 bc 24 78 02 00 	cmpq   $0xffffffffffffffff,0x278(%rsp)
  1841f8:	00 ff 
  1841fa:	0f 84 1d 13 00 00    	je     18551d <allocation_pmu_probe::main+0x18ad>
  184200:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  184207:	00 
  184208:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  18420f:	00 
  184210:	ba c8 03 00 00       	mov    $0x3c8,%edx
  184215:	ff 15 c5 2e 4c 00    	call   *0x4c2ec5(%rip)        # 6470e0 <memcpy@GLIBC_2.14>
  18421b:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  184222:	00 00 
  184224:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  18422b:	00 00 
  18422d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  184234:	00 00 
  184236:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  18423d:	00 00 
  18423f:	ff 15 7b 2e 4c 00    	call   *0x4c2e7b(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184245:	bf 03 00 00 00       	mov    $0x3,%edi
  18424a:	be 01 00 00 00       	mov    $0x1,%esi
  18424f:	ff 15 73 2e 4c 00    	call   *0x4c2e73(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184255:	48 85 c0             	test   %rax,%rax
  184258:	0f 84 5d 16 00 00    	je     1858bb <allocation_pmu_probe::main+0x1c4b>
  18425e:	49 89 c6             	mov    %rax,%r14
  184261:	c6 40 02 30          	movb   $0x30,0x2(%rax)
  184265:	66 c7 00 69 64       	movw   $0x6469,(%rax)
  18426a:	48 c7 84 24 30 01 00 	movq   $0x3,0x130(%rsp)
  184271:	00 03 00 00 00 
  184276:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  18427d:	00 
  18427e:	48 c7 84 24 40 01 00 	movq   $0x3,0x140(%rsp)
  184285:	00 03 00 00 00 
  18428a:	ff 15 30 2e 4c 00    	call   *0x4c2e30(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184290:	bf 06 00 00 00       	mov    $0x6,%edi
  184295:	be 01 00 00 00       	mov    $0x1,%esi
  18429a:	ff 15 28 2e 4c 00    	call   *0x4c2e28(%rip)        # 6470c8 <_DYNAMIC+0x268>
  1842a0:	48 85 c0             	test   %rax,%rax
  1842a3:	0f 84 24 16 00 00    	je     1858cd <allocation_pmu_probe::main+0x1c5d>
  1842a9:	66 c7 40 04 5f 30    	movw   $0x305f,0x4(%rax)
  1842af:	c7 00 6e 65 77 30    	movl   $0x3077656e,(%rax)
  1842b5:	c6 84 24 78 02 00 00 	movb   $0x3,0x278(%rsp)
  1842bc:	03 
  1842bd:	48 c7 84 24 80 02 00 	movq   $0x6,0x280(%rsp)
  1842c4:	00 06 00 00 00 
  1842c9:	48 89 84 24 88 02 00 	mov    %rax,0x288(%rsp)
  1842d0:	00 
  1842d1:	48 c7 84 24 90 02 00 	movq   $0x6,0x290(%rsp)
  1842d8:	00 06 00 00 00 
  1842dd:	4c 8d b4 24 40 06 00 	lea    0x640(%rsp),%r14
  1842e4:	00 
  1842e5:	48 8d 6c 24 20       	lea    0x20(%rsp),%rbp
  1842ea:	48 8d 9c 24 30 01 00 	lea    0x130(%rsp),%rbx
  1842f1:	00 
  1842f2:	48 8d 8c 24 78 02 00 	lea    0x278(%rsp),%rcx
  1842f9:	00 
  1842fa:	4c 89 f7             	mov    %r14,%rdi
  1842fd:	48 89 ee             	mov    %rbp,%rsi
  184300:	48 89 da             	mov    %rbx,%rdx
  184303:	e8 58 b1 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184308:	80 bc 24 40 06 00 00 	cmpb   $0xff,0x640(%rsp)
  18430f:	ff 
  184310:	74 0d                	je     18431f <allocation_pmu_probe::main+0x6af>
  184312:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  184319:	00 
  18431a:	e8 21 ef ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  18431f:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  184324:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  184329:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  18432e:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  184335:	00 
  184336:	c6 44 24 68 05       	movb   $0x5,0x68(%rsp)
  18433b:	48 c7 84 24 38 01 00 	movq   $0x0,0x138(%rsp)
  184342:	00 00 00 00 00 
  184347:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  18434e:	00 00 00 00 00 
  184353:	c6 84 24 30 01 00 00 	movb   $0x5,0x130(%rsp)
  18435a:	05 
  18435b:	48 c7 84 24 40 06 00 	movq   $0xffffffffffffffff,0x640(%rsp)
  184362:	00 ff ff ff ff 
  184367:	48 83 ec 08          	sub    $0x8,%rsp
  18436b:	48 8d 05 39 0b ef ff 	lea    -0x10f4c7(%rip),%rax        # 74eab <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xf2>
  184372:	4c 8d 54 24 70       	lea    0x70(%rsp),%r10
  184377:	48 8d 0d 27 0b ef ff 	lea    -0x10f4d9(%rip),%rcx        # 74ea5 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xec>
  18437e:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
  184385:	00 
  184386:	48 8d b4 24 a8 08 00 	lea    0x8a8(%rsp),%rsi
  18438d:	00 
  18438e:	48 8d 94 24 70 0c 00 	lea    0xc70(%rsp),%rdx
  184395:	00 
  184396:	4c 8d 4c 24 10       	lea    0x10(%rsp),%r9
  18439b:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  1843a1:	41 56                	push   %r14
  1843a3:	6a 14                	push   $0x14
  1843a5:	50                   	push   %rax
  1843a6:	53                   	push   %rbx
  1843a7:	41 52                	push   %r10
  1843a9:	e8 32 76 fb ff       	call   13b9e0 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::evaluate>
  1843ae:	48 83 c4 30          	add    $0x30,%rsp
  1843b2:	48 83 bc 24 78 02 00 	cmpq   $0xfffffffffffffffe,0x278(%rsp)
  1843b9:	00 fe 
  1843bb:	0f 84 e9 11 00 00    	je     1855aa <allocation_pmu_probe::main+0x193a>
  1843c1:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  1843c8:	00 
  1843c9:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  1843d0:	00 
  1843d1:	ba 58 02 00 00       	mov    $0x258,%edx
  1843d6:	ff 15 04 2d 4c 00    	call   *0x4c2d04(%rip)        # 6470e0 <memcpy@GLIBC_2.14>
  1843dc:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  1843e3:	00 
  1843e4:	e8 57 ee ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  1843e9:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1843ee:	e8 4d ee ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  1843f3:	45 31 f6             	xor    %r14d,%r14d
  1843f6:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  1843fb:	e8 b0 21 fd ff       	call   1565b0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  184400:	48 8d 94 24 78 08 00 	lea    0x878(%rsp),%rdx
  184407:	00 
  184408:	45 31 f6             	xor    %r14d,%r14d
  18440b:	48 8d 3d ad 0a ef ff 	lea    -0x10f553(%rip),%rdi        # 74ebf <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x106>
  184412:	be 06 00 00 00       	mov    $0x6,%esi
  184417:	ff 15 db 2d 4c 00    	call   *0x4c2ddb(%rip)        # 6471f8 <_DYNAMIC+0x398>
  18441d:	48 85 c0             	test   %rax,%rax
  184420:	75 07                	jne    184429 <allocation_pmu_probe::main+0x7b9>
  184422:	48 8b 05 d7 2d 4c 00 	mov    0x4c2dd7(%rip),%rax        # 647200 <_DYNAMIC+0x3a0>
  184429:	80 38 03             	cmpb   $0x3,(%rax)
  18442c:	0f 85 b5 0f 00 00    	jne    1853e7 <allocation_pmu_probe::main+0x1777>
  184432:	48 83 78 18 05       	cmpq   $0x5,0x18(%rax)
  184437:	0f 85 aa 0f 00 00    	jne    1853e7 <allocation_pmu_probe::main+0x1777>
  18443d:	48 8b 48 10          	mov    0x10(%rax),%rcx
  184441:	ba 41 4c 4c 4f       	mov    $0x4f4c4c41,%edx
  184446:	33 11                	xor    (%rcx),%edx
  184448:	0f b6 49 04          	movzbl 0x4(%rcx),%ecx
  18444c:	83 f1 57             	xor    $0x57,%ecx
  18444f:	09 d1                	or     %edx,%ecx
  184451:	0f 85 90 0f 00 00    	jne    1853e7 <allocation_pmu_probe::main+0x1777>
  184457:	48 8b 84 24 40 06 00 	mov    0x640(%rsp),%rax
  18445e:	00 
  18445f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  184463:	0f 84 ce 11 00 00    	je     185637 <allocation_pmu_probe::main+0x19c7>
  184469:	48 8d b4 24 48 06 00 	lea    0x648(%rsp),%rsi
  184470:	00 
  184471:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  184478:	00 
  184479:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
  184480:	00 
  184481:	ba 30 02 00 00       	mov    $0x230,%edx
  184486:	ff 15 54 2c 4c 00    	call   *0x4c2c54(%rip)        # 6470e0 <memcpy@GLIBC_2.14>
  18448c:	48 8d 8c 24 90 02 00 	lea    0x290(%rsp),%rcx
  184493:	00 
  184494:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  184499:	48 8d b4 24 a0 08 00 	lea    0x8a0(%rsp),%rsi
  1844a0:	00 
  1844a1:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  1844a8:	00 
  1844a9:	4c 8d 84 24 78 02 00 	lea    0x278(%rsp),%r8
  1844b0:	00 
  1844b1:	48 89 df             	mov    %rbx,%rdi
  1844b4:	45 31 c9             	xor    %r9d,%r9d
  1844b7:	e8 d4 72 fa ff       	call   12b790 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::commit_impl>
  1844bc:	48 83 7c 24 68 ff    	cmpq   $0xffffffffffffffff,0x68(%rsp)
  1844c2:	0f 85 84 11 00 00    	jne    18564c <allocation_pmu_probe::main+0x19dc>
  1844c8:	0f 10 84 24 b0 00 00 	movups 0xb0(%rsp),%xmm0
  1844cf:	00 
  1844d0:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  1844d7:	00 
  1844d8:	0f 10 44 24 70       	movups 0x70(%rsp),%xmm0
  1844dd:	0f 10 8c 24 80 00 00 	movups 0x80(%rsp),%xmm1
  1844e4:	00 
  1844e5:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  1844ec:	00 
  1844ed:	0f 10 9c 24 a0 00 00 	movups 0xa0(%rsp),%xmm3
  1844f4:	00 
  1844f5:	0f 29 9c 24 60 01 00 	movaps %xmm3,0x160(%rsp)
  1844fc:	00 
  1844fd:	0f 29 94 24 50 01 00 	movaps %xmm2,0x150(%rsp)
  184504:	00 
  184505:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
  18450c:	00 
  18450d:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  184514:	00 
  184515:	80 bc 24 78 01 00 00 	cmpb   $0x0,0x178(%rsp)
  18451c:	00 
  18451d:	0f 85 b0 11 00 00    	jne    1856d3 <allocation_pmu_probe::main+0x1a63>
  184523:	48 83 bc 24 60 01 00 	cmpq   $0x1,0x160(%rsp)
  18452a:	00 01 
  18452c:	0f 85 bf 11 00 00    	jne    1856f1 <allocation_pmu_probe::main+0x1a81>
  184532:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  184537:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
  18453c:	ba 01 00 00 00       	mov    $0x1,%edx
  184541:	e8 da 17 00 00       	call   185d20 <allocation_pmu_probe::control>
  184546:	ff 15 34 31 4c 00    	call   *0x4c3134(%rip)        # 647680 <_DYNAMIC+0x820>
  18454c:	48 89 84 24 c8 01 00 	mov    %rax,0x1c8(%rsp)
  184553:	00 
  184554:	89 94 24 d0 01 00 00 	mov    %edx,0x1d0(%rsp)
  18455b:	b8 61 6c 6c 6f       	mov    $0x6f6c6c61,%eax
  184560:	48 8b 8c 24 28 01 00 	mov    0x128(%rsp),%rcx
  184567:	00 
  184568:	33 01                	xor    (%rcx),%eax
  18456a:	0f b6 49 04          	movzbl 0x4(%rcx),%ecx
  18456e:	83 f1 63             	xor    $0x63,%ecx
  184571:	09 c1                	or     %eax,%ecx
  184573:	74 23                	je     184598 <allocation_pmu_probe::main+0x928>
  184575:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  18457c:	00 
  18457d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  184584:	00 
  184585:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  18458a:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  18458f:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  184596:	eb 72                	jmp    18460a <allocation_pmu_probe::main+0x99a>
  184598:	4c 8b b4 24 20 01 00 	mov    0x120(%rsp),%r14
  18459f:	00 
  1845a0:	4d 85 f6             	test   %r14,%r14
  1845a3:	74 2c                	je     1845d1 <allocation_pmu_probe::main+0x961>
  1845a5:	ff 15 15 2b 4c 00    	call   *0x4c2b15(%rip)        # 6470c0 <_DYNAMIC+0x260>
  1845ab:	be 01 00 00 00       	mov    $0x1,%esi
  1845b0:	4c 89 f7             	mov    %r14,%rdi
  1845b3:	ff 15 0f 2b 4c 00    	call   *0x4c2b0f(%rip)        # 6470c8 <_DYNAMIC+0x268>
  1845b9:	48 85 c0             	test   %rax,%rax
  1845bc:	75 18                	jne    1845d6 <allocation_pmu_probe::main+0x966>
  1845be:	bf 01 00 00 00       	mov    $0x1,%edi
  1845c3:	4c 89 f6             	mov    %r14,%rsi
  1845c6:	ff 15 7c 2b 4c 00    	call   *0x4c2b7c(%rip)        # 647148 <_DYNAMIC+0x2e8>
  1845cc:	e9 4c 13 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1845d1:	b8 01 00 00 00       	mov    $0x1,%eax
  1845d6:	4c 89 b4 24 e8 00 00 	mov    %r14,0xe8(%rsp)
  1845dd:	00 
  1845de:	4c 89 74 24 68       	mov    %r14,0x68(%rsp)
  1845e3:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  1845e8:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  1845ef:	00 00 
  1845f1:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  1845f6:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  1845fb:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
  184600:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  184605:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  18460a:	48 8d bc 24 c8 01 00 	lea    0x1c8(%rsp),%rdi
  184611:	00 
  184612:	ff 15 70 30 4c 00    	call   *0x4c3070(%rip)        # 647688 <_DYNAMIC+0x828>
  184618:	89 d1                	mov    %edx,%ecx
  18461a:	ba 00 ca 9a 3b       	mov    $0x3b9aca00,%edx
  18461f:	48 f7 e2             	mul    %rdx
  184622:	89 c9                	mov    %ecx,%ecx
  184624:	48 01 c1             	add    %rax,%rcx
  184627:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  18462e:	00 
  18462f:	48 83 d2 00          	adc    $0x0,%rdx
  184633:	48 89 94 24 a8 01 00 	mov    %rdx,0x1a8(%rsp)
  18463a:	00 
  18463b:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  184640:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
  184645:	31 d2                	xor    %edx,%edx
  184647:	e8 d4 16 00 00       	call   185d20 <allocation_pmu_probe::control>
  18464c:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  184650:	75 37                	jne    184689 <allocation_pmu_probe::main+0xa19>
  184652:	4c 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%r14
  184659:	00 
  18465a:	4d 85 f6             	test   %r14,%r14
  18465d:	74 22                	je     184681 <allocation_pmu_probe::main+0xa11>
  18465f:	ff 15 5b 2a 4c 00    	call   *0x4c2a5b(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184665:	be 01 00 00 00       	mov    $0x1,%esi
  18466a:	4c 89 f7             	mov    %r14,%rdi
  18466d:	ff 15 55 2a 4c 00    	call   *0x4c2a55(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184673:	48 85 c0             	test   %rax,%rax
  184676:	0f 84 93 12 00 00    	je     18590f <allocation_pmu_probe::main+0x1c9f>
  18467c:	49 89 c4             	mov    %rax,%r12
  18467f:	eb 06                	jmp    184687 <allocation_pmu_probe::main+0xa17>
  184681:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  184687:	31 db                	xor    %ebx,%ebx
  184689:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
  18468e:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
  184693:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  184698:	4c 89 b4 24 c0 01 00 	mov    %r14,0x1c0(%rsp)
  18469f:	00 
  1846a0:	ff 15 da 2f 4c 00    	call   *0x4c2fda(%rip)        # 647680 <_DYNAMIC+0x820>
  1846a6:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
  1846ad:	00 
  1846ae:	89 94 24 e0 01 00 00 	mov    %edx,0x1e0(%rsp)
  1846b5:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
  1846ba:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  1846bf:	0f b6 84 24 78 08 00 	movzbl 0x878(%rsp),%eax
  1846c6:	00 
  1846c7:	48 8d 0d 46 07 ef ff 	lea    -0x10f8ba(%rip),%rcx        # 74e14 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x5b>
  1846ce:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  1846d2:	48 01 c8             	add    %rcx,%rax
  1846d5:	ff e0                	jmp    *%rax
  1846d7:	bb 04 00 00 00       	mov    $0x4,%ebx
  1846dc:	4c 8d 25 ad ed ee ff 	lea    -0x111253(%rip),%r12        # 73490 <anon.6acf7906abde1bbb8e33a7bfb9d0a309.167.llvm.16459698112127296997>
  1846e3:	e9 b2 00 00 00       	jmp    18479a <allocation_pmu_probe::main+0xb2a>
  1846e8:	48 8d b4 24 80 08 00 	lea    0x880(%rsp),%rsi
  1846ef:	00 
  1846f0:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1846f5:	e8 d6 26 ff ff       	call   176dd0 <<&mut serde_json::ser::Serializer<&mut alloc::vec::Vec<u8>> as serde_core::ser::Serializer>::collect_seq::<&alloc::vec::Vec<serde_json::value::Value>>>
  1846fa:	eb 12                	jmp    18470e <allocation_pmu_probe::main+0xa9e>
  1846fc:	48 8d bc 24 80 08 00 	lea    0x880(%rsp),%rdi
  184703:	00 
  184704:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  184709:	e8 72 3e ff ff       	call   178580 <<serde_json::number::Number as serde_core::ser::Serialize>::serialize::<&mut serde_json::ser::Serializer<&mut alloc::vec::Vec<u8>>>>
  18470e:	48 85 c0             	test   %rax,%rax
  184711:	0f 84 7a 03 00 00    	je     184a91 <allocation_pmu_probe::main+0xe21>
  184717:	eb 31                	jmp    18474a <allocation_pmu_probe::main+0xada>
  184719:	48 8b 94 24 88 08 00 	mov    0x888(%rsp),%rdx
  184720:	00 
  184721:	48 8b 8c 24 90 08 00 	mov    0x890(%rsp),%rcx
  184728:	00 
  184729:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  18472e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184733:	e8 a8 0d ff ff       	call   1754e0 <serde_json::ser::format_escaped_str::<&mut alloc::vec::Vec<u8>, serde_json::ser::CompactFormatter>>
  184738:	48 85 c0             	test   %rax,%rax
  18473b:	0f 84 50 03 00 00    	je     184a91 <allocation_pmu_probe::main+0xe21>
  184741:	48 89 c7             	mov    %rax,%rdi
  184744:	ff 15 46 2f 4c 00    	call   *0x4c2f46(%rip)        # 647690 <_DYNAMIC+0x830>
  18474a:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  18474f:	48 8d 3d f3 07 ef ff 	lea    -0x10f80d(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  184756:	48 8d 0d c3 8f 4b 00 	lea    0x4b8fc3(%rip),%rcx        # 63d720 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  18475d:	4c 8d 05 54 8e 4b 00 	lea    0x4b8e54(%rip),%r8        # 63d5b8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x118>
  184764:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  184769:	be 2b 00 00 00       	mov    $0x2b,%esi
  18476e:	ff 15 4c 2a 4c 00    	call   *0x4c2a4c(%rip)        # 6471c0 <_DYNAMIC+0x360>
  184774:	e9 a4 11 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  184779:	0f b6 9c 24 79 08 00 	movzbl 0x879(%rsp),%ebx
  184780:	00 
  184781:	48 8d 05 1c ed ee ff 	lea    -0x1112e4(%rip),%rax        # 734a4 <anon.1cb71ff3762624ae304e4a0523993dab.9.llvm.2568929261584004968>
  184788:	4c 8d 25 dd 06 ef ff 	lea    -0x10f923(%rip),%r12        # 74e6c <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xb3>
  18478f:	48 85 db             	test   %rbx,%rbx
  184792:	4c 0f 45 e0          	cmovne %rax,%r12
  184796:	48 83 f3 05          	xor    $0x5,%rbx
  18479a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  18479f:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  1847a4:	48 29 e8             	sub    %rbp,%rax
  1847a7:	48 39 c3             	cmp    %rax,%rbx
  1847aa:	0f 87 20 10 00 00    	ja     1857d0 <allocation_pmu_probe::main+0x1b60>
  1847b0:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  1847b5:	48 01 ef             	add    %rbp,%rdi
  1847b8:	4c 89 e6             	mov    %r12,%rsi
  1847bb:	48 89 da             	mov    %rbx,%rdx
  1847be:	ff 15 1c 29 4c 00    	call   *0x4c291c(%rip)        # 6470e0 <memcpy@GLIBC_2.14>
  1847c4:	48 01 dd             	add    %rbx,%rbp
  1847c7:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  1847cc:	e9 c0 02 00 00       	jmp    184a91 <allocation_pmu_probe::main+0xe21>
  1847d1:	4c 8b a4 24 90 08 00 	mov    0x890(%rsp),%r12
  1847d8:	00 
  1847d9:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  1847de:	48 39 74 24 48       	cmp    %rsi,0x48(%rsp)
  1847e3:	0f 84 0c 10 00 00    	je     1857f5 <allocation_pmu_probe::main+0x1b85>
  1847e9:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  1847ee:	c6 04 30 7b          	movb   $0x7b,(%rax,%rsi,1)
  1847f2:	48 ff c6             	inc    %rsi
  1847f5:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  1847fa:	b0 01                	mov    $0x1,%al
  1847fc:	4d 85 e4             	test   %r12,%r12
  1847ff:	75 1e                	jne    18481f <allocation_pmu_probe::main+0xbaf>
  184801:	48 39 74 24 48       	cmp    %rsi,0x48(%rsp)
  184806:	0f 84 40 10 00 00    	je     18584c <allocation_pmu_probe::main+0x1bdc>
  18480c:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  184811:	c6 04 30 7d          	movb   $0x7d,(%rax,%rsi,1)
  184815:	48 ff c6             	inc    %rsi
  184818:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  18481d:	31 c0                	xor    %eax,%eax
  18481f:	4c 89 b4 24 e0 00 00 	mov    %r14,0xe0(%rsp)
  184826:	00 
  184827:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
  18482c:	88 44 24 70          	mov    %al,0x70(%rsp)
  184830:	48 8b 8c 24 80 08 00 	mov    0x880(%rsp),%rcx
  184837:	00 
  184838:	4c 8b b4 24 88 08 00 	mov    0x888(%rsp),%r14
  18483f:	00 
  184840:	48 85 c9             	test   %rcx,%rcx
  184843:	0f 95 c2             	setne  %dl
  184846:	4c 0f 44 e1          	cmove  %rcx,%r12
  18484a:	31 ed                	xor    %ebp,%ebp
  18484c:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  184851:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  184858:	0f 1f 84 00 00 00 00 
  18485f:	00 
  184860:	49 83 ec 01          	sub    $0x1,%r12
  184864:	0f 82 f4 01 00 00    	jb     184a5e <allocation_pmu_probe::main+0xdee>
  18486a:	f6 c2 01             	test   $0x1,%dl
  18486d:	0f 84 1e 10 00 00    	je     185891 <allocation_pmu_probe::main+0x1c21>
  184873:	48 85 ed             	test   %rbp,%rbp
  184876:	74 28                	je     1848a0 <allocation_pmu_probe::main+0xc30>
  184878:	0f b7 85 72 02 00 00 	movzwl 0x272(%rbp),%eax
  18487f:	49 39 c6             	cmp    %rax,%r14
  184882:	0f 83 c8 00 00 00    	jae    184950 <allocation_pmu_probe::main+0xce0>
  184888:	48 89 e8             	mov    %rbp,%rax
  18488b:	4c 89 f2             	mov    %r14,%rdx
  18488e:	e9 e3 00 00 00       	jmp    184976 <allocation_pmu_probe::main+0xd06>
  184893:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  18489a:	84 00 00 00 00 00 
  1848a0:	4d 85 f6             	test   %r14,%r14
  1848a3:	74 38                	je     1848dd <allocation_pmu_probe::main+0xc6d>
  1848a5:	4c 89 f0             	mov    %r14,%rax
  1848a8:	48 89 cd             	mov    %rcx,%rbp
  1848ab:	48 83 e0 07          	and    $0x7,%rax
  1848af:	74 31                	je     1848e2 <allocation_pmu_probe::main+0xc72>
  1848b1:	31 c9                	xor    %ecx,%ecx
  1848b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1848ba:	84 00 00 00 00 00 
  1848c0:	48 8b ad 78 02 00 00 	mov    0x278(%rbp),%rbp
  1848c7:	48 ff c1             	inc    %rcx
  1848ca:	48 39 c8             	cmp    %rcx,%rax
  1848cd:	75 f1                	jne    1848c0 <allocation_pmu_probe::main+0xc50>
  1848cf:	4c 89 f0             	mov    %r14,%rax
  1848d2:	48 29 c8             	sub    %rcx,%rax
  1848d5:	49 83 fe 08          	cmp    $0x8,%r14
  1848d9:	73 15                	jae    1848f0 <allocation_pmu_probe::main+0xc80>
  1848db:	eb 51                	jmp    18492e <allocation_pmu_probe::main+0xcbe>
  1848dd:	48 89 cd             	mov    %rcx,%rbp
  1848e0:	eb 4c                	jmp    18492e <allocation_pmu_probe::main+0xcbe>
  1848e2:	4c 89 f0             	mov    %r14,%rax
  1848e5:	49 83 fe 08          	cmp    $0x8,%r14
  1848e9:	72 43                	jb     18492e <allocation_pmu_probe::main+0xcbe>
  1848eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  1848f0:	48 8b 8d 78 02 00 00 	mov    0x278(%rbp),%rcx
  1848f7:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1848fe:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  184905:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18490c:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  184913:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18491a:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  184921:	48 8b a9 78 02 00 00 	mov    0x278(%rcx),%rbp
  184928:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  18492c:	75 c2                	jne    1848f0 <allocation_pmu_probe::main+0xc80>
  18492e:	45 31 f6             	xor    %r14d,%r14d
  184931:	31 c9                	xor    %ecx,%ecx
  184933:	0f b7 85 72 02 00 00 	movzwl 0x272(%rbp),%eax
  18493a:	49 39 c6             	cmp    %rax,%r14
  18493d:	0f 82 45 ff ff ff    	jb     184888 <allocation_pmu_probe::main+0xc18>
  184943:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  18494a:	84 00 00 00 00 00 
  184950:	48 8b 85 60 01 00 00 	mov    0x160(%rbp),%rax
  184957:	48 85 c0             	test   %rax,%rax
  18495a:	0f 84 b9 0e 00 00    	je     185819 <allocation_pmu_probe::main+0x1ba9>
  184960:	48 ff c1             	inc    %rcx
  184963:	0f b7 95 70 02 00 00 	movzwl 0x270(%rbp),%edx
  18496a:	48 89 c5             	mov    %rax,%rbp
  18496d:	66 3b 90 72 02 00 00 	cmp    0x272(%rax),%dx
  184974:	73 da                	jae    184950 <allocation_pmu_probe::main+0xce0>
  184976:	48 85 c9             	test   %rcx,%rcx
  184979:	0f 84 91 00 00 00    	je     184a10 <allocation_pmu_probe::main+0xda0>
  18497f:	48 8d 34 d0          	lea    (%rax,%rdx,8),%rsi
  184983:	48 81 c6 80 02 00 00 	add    $0x280,%rsi
  18498a:	48 89 cf             	mov    %rcx,%rdi
  18498d:	48 83 e7 07          	and    $0x7,%rdi
  184991:	0f 84 b9 00 00 00    	je     184a50 <allocation_pmu_probe::main+0xde0>
  184997:	45 31 c0             	xor    %r8d,%r8d
  18499a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  1849a0:	48 8b 2e             	mov    (%rsi),%rbp
  1849a3:	48 8d b5 78 02 00 00 	lea    0x278(%rbp),%rsi
  1849aa:	49 ff c0             	inc    %r8
  1849ad:	4c 39 c7             	cmp    %r8,%rdi
  1849b0:	75 ee                	jne    1849a0 <allocation_pmu_probe::main+0xd30>
  1849b2:	48 89 cf             	mov    %rcx,%rdi
  1849b5:	4c 29 c7             	sub    %r8,%rdi
  1849b8:	48 83 f9 08          	cmp    $0x8,%rcx
  1849bc:	72 43                	jb     184a01 <allocation_pmu_probe::main+0xd91>
  1849be:	66 90                	xchg   %ax,%ax
  1849c0:	48 8b 0e             	mov    (%rsi),%rcx
  1849c3:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1849ca:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1849d1:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1849d8:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1849df:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1849e6:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1849ed:	48 8b a9 78 02 00 00 	mov    0x278(%rcx),%rbp
  1849f4:	48 8d b5 78 02 00 00 	lea    0x278(%rbp),%rsi
  1849fb:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  1849ff:	75 bf                	jne    1849c0 <allocation_pmu_probe::main+0xd50>
  184a01:	45 31 f6             	xor    %r14d,%r14d
  184a04:	eb 11                	jmp    184a17 <allocation_pmu_probe::main+0xda7>
  184a06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  184a0d:	00 00 00 
  184a10:	4c 8d 72 01          	lea    0x1(%rdx),%r14
  184a14:	48 89 c5             	mov    %rax,%rbp
  184a17:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  184a1b:	48 8d 34 c8          	lea    (%rax,%rcx,8),%rsi
  184a1f:	48 81 c6 68 01 00 00 	add    $0x168,%rsi
  184a26:	48 c1 e2 05          	shl    $0x5,%rdx
  184a2a:	48 01 c2             	add    %rax,%rdx
  184a2d:	48 89 df             	mov    %rbx,%rdi
  184a30:	e8 ab 1f ff ff       	call   1769e0 <<serde_json::ser::Compound<&mut alloc::vec::Vec<u8>, serde_json::ser::CompactFormatter> as serde_core::ser::SerializeMap>::serialize_entry::<alloc::string::String, serde_json::value::Value>>
  184a35:	b2 01                	mov    $0x1,%dl
  184a37:	b9 00 00 00 00       	mov    $0x0,%ecx
  184a3c:	48 85 c0             	test   %rax,%rax
  184a3f:	0f 84 1b fe ff ff    	je     184860 <allocation_pmu_probe::main+0xbf0>
  184a45:	e9 00 fd ff ff       	jmp    18474a <allocation_pmu_probe::main+0xada>
  184a4a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  184a50:	48 89 cf             	mov    %rcx,%rdi
  184a53:	48 83 f9 08          	cmp    $0x8,%rcx
  184a57:	72 a8                	jb     184a01 <allocation_pmu_probe::main+0xd91>
  184a59:	e9 62 ff ff ff       	jmp    1849c0 <allocation_pmu_probe::main+0xd50>
  184a5e:	80 7c 24 70 00       	cmpb   $0x0,0x70(%rsp)
  184a63:	4c 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14
  184a6a:	00 
  184a6b:	74 24                	je     184a91 <allocation_pmu_probe::main+0xe21>
  184a6d:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  184a72:	48 8b 18             	mov    (%rax),%rbx
  184a75:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  184a79:	48 39 33             	cmp    %rsi,(%rbx)
  184a7c:	0f 84 a9 0d 00 00    	je     18582b <allocation_pmu_probe::main+0x1bbb>
  184a82:	48 8b 43 08          	mov    0x8(%rbx),%rax
  184a86:	c6 04 30 7d          	movb   $0x7d,(%rax,%rsi,1)
  184a8a:	48 ff c6             	inc    %rsi
  184a8d:	48 89 73 10          	mov    %rsi,0x10(%rbx)
  184a91:	48 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%rdi
  184a98:	00 
  184a99:	ff 15 e9 2b 4c 00    	call   *0x4c2be9(%rip)        # 647688 <_DYNAMIC+0x828>
  184a9f:	89 d1                	mov    %edx,%ecx
  184aa1:	ba 00 ca 9a 3b       	mov    $0x3b9aca00,%edx
  184aa6:	48 f7 e2             	mul    %rdx
  184aa9:	49 89 d4             	mov    %rdx,%r12
  184aac:	89 cb                	mov    %ecx,%ebx
  184aae:	48 01 c3             	add    %rax,%rbx
  184ab1:	49 83 d4 00          	adc    $0x0,%r12
  184ab5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  184aba:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  184abf:	49 39 c6             	cmp    %rax,%r14
  184ac2:	0f 85 4e 0c 00 00    	jne    185716 <allocation_pmu_probe::main+0x1aa6>
  184ac8:	49 8b bf 98 00 00 00 	mov    0x98(%r15),%rdi
  184acf:	49 8b b7 a0 00 00 00 	mov    0xa0(%r15),%rsi
  184ad6:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  184adb:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  184ae0:	ff 15 0a 2b 4c 00    	call   *0x4c2b0a(%rip)        # 6475f0 <_DYNAMIC+0x790>
  184ae6:	48 85 c0             	test   %rax,%rax
  184ae9:	0f 85 4a 0c 00 00    	jne    185739 <allocation_pmu_probe::main+0x1ac9>
  184aef:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
  184af6:	00 
  184af7:	48 39 54 24 58       	cmp    %rdx,0x58(%rsp)
  184afc:	0f 85 07 09 00 00    	jne    185409 <allocation_pmu_probe::main+0x1799>
  184b02:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
  184b09:	00 
  184b0a:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  184b0f:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  184b16:	00 
  184b17:	ff 15 03 26 4c 00    	call   *0x4c2603(%rip)        # 647120 <bcmp@GLIBC_2.2.5>
  184b1d:	85 c0                	test   %eax,%eax
  184b1f:	0f 85 e4 08 00 00    	jne    185409 <allocation_pmu_probe::main+0x1799>
  184b25:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  184b2c:	00 00 00 00 00 
  184b31:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  184b38:	00 00 00 00 00 
  184b3d:	ff 15 7d 25 4c 00    	call   *0x4c257d(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184b43:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  184b49:	bf 01 00 00 00       	mov    $0x1,%edi
  184b4e:	be 01 00 00 00       	mov    $0x1,%esi
  184b53:	ff 15 6f 25 4c 00    	call   *0x4c256f(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184b59:	48 85 c0             	test   %rax,%rax
  184b5c:	0f 84 1c 0d 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184b62:	c6 00 6e             	movb   $0x6e,(%rax)
  184b65:	48 c7 44 24 08 01 00 	movq   $0x1,0x8(%rsp)
  184b6c:	00 00 
  184b6e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  184b73:	48 c7 44 24 18 01 00 	movq   $0x1,0x18(%rsp)
  184b7a:	00 00 
  184b7c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  184b83:	00 
  184b84:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  184b89:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  184b90:	00 00 
  184b92:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  184b97:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184b9c:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184ba3:	00 
  184ba4:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184ba9:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  184bae:	e8 ad a8 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184bb3:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  184bb8:	74 0a                	je     184bc4 <allocation_pmu_probe::main+0xf54>
  184bba:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184bbf:	e8 7c e6 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184bc4:	ff 15 f6 24 4c 00    	call   *0x4c24f6(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184bca:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  184bd0:	bf 08 00 00 00       	mov    $0x8,%edi
  184bd5:	be 01 00 00 00       	mov    $0x1,%esi
  184bda:	ff 15 e8 24 4c 00    	call   *0x4c24e8(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184be0:	48 85 c0             	test   %rax,%rax
  184be3:	0f 84 95 0c 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184be9:	48 b9 63 6f 6d 6d 61 	movabs $0x73646e616d6d6f63,%rcx
  184bf0:	6e 64 73 
  184bf3:	48 89 08             	mov    %rcx,(%rax)
  184bf6:	48 c7 44 24 08 08 00 	movq   $0x8,0x8(%rsp)
  184bfd:	00 00 
  184bff:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  184c04:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  184c0b:	00 00 
  184c0d:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  184c12:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  184c19:	00 00 
  184c1b:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
  184c20:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184c25:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184c2c:	00 
  184c2d:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184c32:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  184c37:	e8 24 a8 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184c3c:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  184c41:	74 0a                	je     184c4d <allocation_pmu_probe::main+0xfdd>
  184c43:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184c48:	e8 f3 e5 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184c4d:	ff 15 6d 24 4c 00    	call   *0x4c246d(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184c53:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  184c59:	bf 04 00 00 00       	mov    $0x4,%edi
  184c5e:	be 01 00 00 00       	mov    $0x1,%esi
  184c63:	ff 15 5f 24 4c 00    	call   *0x4c245f(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184c69:	48 85 c0             	test   %rax,%rax
  184c6c:	0f 84 0c 0c 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184c72:	49 89 c5             	mov    %rax,%r13
  184c75:	4c 89 f5             	mov    %r14,%rbp
  184c78:	c7 00 6d 6f 64 65    	movl   $0x65646f6d,(%rax)
  184c7e:	48 c7 44 24 08 04 00 	movq   $0x4,0x8(%rsp)
  184c85:	00 00 
  184c87:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  184c8c:	48 c7 44 24 18 04 00 	movq   $0x4,0x18(%rsp)
  184c93:	00 00 
  184c95:	ff 15 25 24 4c 00    	call   *0x4c2425(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184c9b:	be 01 00 00 00       	mov    $0x1,%esi
  184ca0:	4c 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%r14
  184ca7:	00 
  184ca8:	4c 89 f7             	mov    %r14,%rdi
  184cab:	ff 15 17 24 4c 00    	call   *0x4c2417(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184cb1:	48 85 c0             	test   %rax,%rax
  184cb4:	0f 84 25 0c 00 00    	je     1858df <allocation_pmu_probe::main+0x1c6f>
  184cba:	49 89 c7             	mov    %rax,%r15
  184cbd:	48 89 c7             	mov    %rax,%rdi
  184cc0:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  184cc7:	00 
  184cc8:	4c 89 f2             	mov    %r14,%rdx
  184ccb:	ff 15 0f 24 4c 00    	call   *0x4c240f(%rip)        # 6470e0 <memcpy@GLIBC_2.14>
  184cd1:	c6 44 24 68 03       	movb   $0x3,0x68(%rsp)
  184cd6:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
  184cdb:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
  184ce0:	4c 89 b4 24 80 00 00 	mov    %r14,0x80(%rsp)
  184ce7:	00 
  184ce8:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184ced:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184cf4:	00 
  184cf5:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184cfa:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  184cff:	e8 5c a7 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184d04:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  184d09:	49 89 ee             	mov    %rbp,%r14
  184d0c:	74 0a                	je     184d18 <allocation_pmu_probe::main+0x10a8>
  184d0e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184d13:	e8 28 e5 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184d18:	ff 15 a2 23 4c 00    	call   *0x4c23a2(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184d1e:	41 bf 0b 00 00 00    	mov    $0xb,%r15d
  184d24:	bf 0b 00 00 00       	mov    $0xb,%edi
  184d29:	be 01 00 00 00       	mov    $0x1,%esi
  184d2e:	ff 15 94 23 4c 00    	call   *0x4c2394(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184d34:	48 85 c0             	test   %rax,%rax
  184d37:	0f 84 41 0b 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184d3d:	49 89 c5             	mov    %rax,%r13
  184d40:	48 b8 64 69 61 67 6e 	movabs $0x74736f6e67616964,%rax
  184d47:	6f 73 74 
  184d4a:	49 89 45 00          	mov    %rax,0x0(%r13)
  184d4e:	41 c7 45 07 74 69 63 	movl   $0x73636974,0x7(%r13)
  184d55:	73 
  184d56:	48 c7 44 24 08 0b 00 	movq   $0xb,0x8(%rsp)
  184d5d:	00 00 
  184d5f:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  184d64:	48 c7 44 24 18 0b 00 	movq   $0xb,0x18(%rsp)
  184d6b:	00 00 
  184d6d:	ff 15 4d 23 4c 00    	call   *0x4c234d(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184d73:	bf 0e 00 00 00       	mov    $0xe,%edi
  184d78:	be 01 00 00 00       	mov    $0x1,%esi
  184d7d:	ff 15 45 23 4c 00    	call   *0x4c2345(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184d83:	48 85 c0             	test   %rax,%rax
  184d86:	0f 84 63 0b 00 00    	je     1858ef <allocation_pmu_probe::main+0x1c7f>
  184d8c:	48 b9 74 69 6f 6e 2d 	movabs $0x756d702d6e6f6974,%rcx
  184d93:	70 6d 75 
  184d96:	48 89 48 06          	mov    %rcx,0x6(%rax)
  184d9a:	48 b9 61 6c 6c 6f 63 	movabs $0x697461636f6c6c61,%rcx
  184da1:	61 74 69 
  184da4:	48 89 08             	mov    %rcx,(%rax)
  184da7:	c6 44 24 68 03       	movb   $0x3,0x68(%rsp)
  184dac:	48 c7 44 24 70 0e 00 	movq   $0xe,0x70(%rsp)
  184db3:	00 00 
  184db5:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  184dba:	48 c7 84 24 80 00 00 	movq   $0xe,0x80(%rsp)
  184dc1:	00 0e 00 00 00 
  184dc6:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184dcb:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184dd2:	00 
  184dd3:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184dd8:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  184ddd:	e8 7e a6 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184de2:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  184de7:	74 0a                	je     184df3 <allocation_pmu_probe::main+0x1183>
  184de9:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184dee:	e8 4d e4 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184df3:	ff 15 c7 22 4c 00    	call   *0x4c22c7(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184df9:	41 bf 09 00 00 00    	mov    $0x9,%r15d
  184dff:	bf 09 00 00 00       	mov    $0x9,%edi
  184e04:	be 01 00 00 00       	mov    $0x1,%esi
  184e09:	ff 15 b9 22 4c 00    	call   *0x4c22b9(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184e0f:	48 85 c0             	test   %rax,%rax
  184e12:	0f 84 66 0a 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184e18:	49 89 c5             	mov    %rax,%r13
  184e1b:	48 b8 77 69 6e 64 6f 	movabs $0x6e5f776f646e6977,%rax
  184e22:	77 5f 6e 
  184e25:	49 89 45 00          	mov    %rax,0x0(%r13)
  184e29:	41 c6 45 08 73       	movb   $0x73,0x8(%r13)
  184e2e:	48 c7 44 24 08 09 00 	movq   $0x9,0x8(%rsp)
  184e35:	00 00 
  184e37:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  184e3c:	48 c7 44 24 18 09 00 	movq   $0x9,0x18(%rsp)
  184e43:	00 00 
  184e45:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  184e4a:	48 8b b4 24 a0 01 00 	mov    0x1a0(%rsp),%rsi
  184e51:	00 
  184e52:	48 8b 94 24 a8 01 00 	mov    0x1a8(%rsp),%rdx
  184e59:	00 
  184e5a:	ff 15 f0 26 4c 00    	call   *0x4c26f0(%rip)        # 647550 <_DYNAMIC+0x6f0>
  184e60:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  184e65:	0f 84 fd 08 00 00    	je     185768 <allocation_pmu_probe::main+0x1af8>
  184e6b:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  184e70:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  184e75:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  184e7a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  184e7f:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  184e84:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184e8b:	00 
  184e8c:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184e91:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  184e96:	e8 c5 a5 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184e9b:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  184ea0:	74 0a                	je     184eac <allocation_pmu_probe::main+0x123c>
  184ea2:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  184ea7:	e8 94 e3 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184eac:	ff 15 0e 22 4c 00    	call   *0x4c220e(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184eb2:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  184eb8:	bf 08 00 00 00       	mov    $0x8,%edi
  184ebd:	be 01 00 00 00       	mov    $0x1,%esi
  184ec2:	ff 15 00 22 4c 00    	call   *0x4c2200(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184ec8:	48 85 c0             	test   %rax,%rax
  184ecb:	0f 84 ad 09 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184ed1:	49 89 c5             	mov    %rax,%r13
  184ed4:	48 b8 77 72 69 74 65 	movabs $0x736e5f6574697277,%rax
  184edb:	5f 6e 73 
  184ede:	49 89 45 00          	mov    %rax,0x0(%r13)
  184ee2:	48 c7 44 24 08 08 00 	movq   $0x8,0x8(%rsp)
  184ee9:	00 00 
  184eeb:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  184ef0:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  184ef7:	00 00 
  184ef9:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  184efe:	48 89 de             	mov    %rbx,%rsi
  184f01:	4c 89 e2             	mov    %r12,%rdx
  184f04:	ff 15 46 26 4c 00    	call   *0x4c2646(%rip)        # 647550 <_DYNAMIC+0x6f0>
  184f0a:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  184f0f:	0f 84 87 08 00 00    	je     18579c <allocation_pmu_probe::main+0x1b2c>
  184f15:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  184f1a:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  184f1f:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  184f24:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  184f29:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  184f2e:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184f35:	00 
  184f36:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184f3b:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  184f40:	e8 1b a5 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184f45:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  184f4a:	74 0a                	je     184f56 <allocation_pmu_probe::main+0x12e6>
  184f4c:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  184f51:	e8 ea e2 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184f56:	ff 15 64 21 4c 00    	call   *0x4c2164(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184f5c:	41 bf 0c 00 00 00    	mov    $0xc,%r15d
  184f62:	bf 0c 00 00 00       	mov    $0xc,%edi
  184f67:	be 01 00 00 00       	mov    $0x1,%esi
  184f6c:	ff 15 56 21 4c 00    	call   *0x4c2156(%rip)        # 6470c8 <_DYNAMIC+0x268>
  184f72:	48 85 c0             	test   %rax,%rax
  184f75:	0f 84 03 09 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  184f7b:	48 b9 72 65 63 6f 72 	movabs $0x625f64726f636572,%rcx
  184f82:	64 5f 62 
  184f85:	48 89 08             	mov    %rcx,(%rax)
  184f88:	c7 40 08 79 74 65 73 	movl   $0x73657479,0x8(%rax)
  184f8f:	48 c7 44 24 08 0c 00 	movq   $0xc,0x8(%rsp)
  184f96:	00 00 
  184f98:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  184f9d:	48 c7 44 24 18 0c 00 	movq   $0xc,0x18(%rsp)
  184fa4:	00 00 
  184fa6:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  184fab:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  184fb0:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  184fb7:	00 00 
  184fb9:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  184fbe:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184fc3:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  184fca:	00 
  184fcb:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  184fd0:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  184fd5:	e8 86 a4 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  184fda:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  184fdf:	74 0a                	je     184feb <allocation_pmu_probe::main+0x137b>
  184fe1:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  184fe6:	e8 55 e2 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  184feb:	ff 15 cf 20 4c 00    	call   *0x4c20cf(%rip)        # 6470c0 <_DYNAMIC+0x260>
  184ff1:	41 bf 0f 00 00 00    	mov    $0xf,%r15d
  184ff7:	bf 0f 00 00 00       	mov    $0xf,%edi
  184ffc:	be 01 00 00 00       	mov    $0x1,%esi
  185001:	ff 15 c1 20 4c 00    	call   *0x4c20c1(%rip)        # 6470c8 <_DYNAMIC+0x268>
  185007:	48 85 c0             	test   %rax,%rax
  18500a:	0f 84 6e 08 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  185010:	48 b9 79 5f 62 65 66 	movabs $0x65726f6665625f79,%rcx
  185017:	6f 72 65 
  18501a:	48 89 48 07          	mov    %rcx,0x7(%rax)
  18501e:	48 bb 63 61 70 61 63 	movabs $0x7974696361706163,%rbx
  185025:	69 74 79 
  185028:	48 89 18             	mov    %rbx,(%rax)
  18502b:	48 c7 44 24 08 0f 00 	movq   $0xf,0x8(%rsp)
  185032:	00 00 
  185034:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  185039:	48 c7 44 24 18 0f 00 	movq   $0xf,0x18(%rsp)
  185040:	00 00 
  185042:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  185047:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  18504e:	00 00 
  185050:	4c 89 74 24 78       	mov    %r14,0x78(%rsp)
  185055:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18505a:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  185061:	00 
  185062:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  185067:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  18506c:	e8 ef a3 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  185071:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  185076:	74 0a                	je     185082 <allocation_pmu_probe::main+0x1412>
  185078:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18507d:	e8 be e1 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  185082:	ff 15 38 20 4c 00    	call   *0x4c2038(%rip)        # 6470c0 <_DYNAMIC+0x260>
  185088:	41 bf 0e 00 00 00    	mov    $0xe,%r15d
  18508e:	bf 0e 00 00 00       	mov    $0xe,%edi
  185093:	be 01 00 00 00       	mov    $0x1,%esi
  185098:	ff 15 2a 20 4c 00    	call   *0x4c202a(%rip)        # 6470c8 <_DYNAMIC+0x268>
  18509e:	48 85 c0             	test   %rax,%rax
  1850a1:	0f 84 d7 07 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  1850a7:	48 b9 74 79 5f 61 66 	movabs $0x72657466615f7974,%rcx
  1850ae:	74 65 72 
  1850b1:	48 89 48 06          	mov    %rcx,0x6(%rax)
  1850b5:	48 89 18             	mov    %rbx,(%rax)
  1850b8:	48 c7 44 24 08 0e 00 	movq   $0xe,0x8(%rsp)
  1850bf:	00 00 
  1850c1:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  1850c6:	48 c7 44 24 18 0e 00 	movq   $0xe,0x18(%rsp)
  1850cd:	00 00 
  1850cf:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  1850d4:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  1850d9:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  1850e0:	00 00 
  1850e2:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  1850e7:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1850ec:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  1850f3:	00 
  1850f4:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  1850f9:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  1850fe:	e8 5d a3 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  185103:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  185108:	74 0a                	je     185114 <allocation_pmu_probe::main+0x14a4>
  18510a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18510f:	e8 2c e1 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  185114:	ff 15 a6 1f 4c 00    	call   *0x4c1fa6(%rip)        # 6470c0 <_DYNAMIC+0x260>
  18511a:	41 bf 09 00 00 00    	mov    $0x9,%r15d
  185120:	bf 09 00 00 00       	mov    $0x9,%edi
  185125:	be 01 00 00 00       	mov    $0x1,%esi
  18512a:	ff 15 98 1f 4c 00    	call   *0x4c1f98(%rip)        # 6470c8 <_DYNAMIC+0x268>
  185130:	48 85 c0             	test   %rax,%rax
  185133:	0f 84 45 07 00 00    	je     18587e <allocation_pmu_probe::main+0x1c0e>
  185139:	48 b9 61 63 6b 5f 62 	movabs $0x657479625f6b6361,%rcx
  185140:	79 74 65 
  185143:	48 89 08             	mov    %rcx,(%rax)
  185146:	c6 40 08 73          	movb   $0x73,0x8(%rax)
  18514a:	48 c7 44 24 08 09 00 	movq   $0x9,0x8(%rsp)
  185151:	00 00 
  185153:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  185158:	48 c7 44 24 18 09 00 	movq   $0x9,0x18(%rsp)
  18515f:	00 00 
  185161:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  185166:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  18516d:	00 00 
  18516f:	48 c7 44 24 78 05 00 	movq   $0x5,0x78(%rsp)
  185176:	00 00 
  185178:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18517d:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  185184:	00 
  185185:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  18518a:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  18518f:	48 89 d9             	mov    %rbx,%rcx
  185192:	e8 c9 a2 fc ff       	call   14f460 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  185197:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  18519c:	74 0a                	je     1851a8 <allocation_pmu_probe::main+0x1538>
  18519e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1851a3:	e8 98 e0 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  1851a8:	0f 10 84 24 c8 00 00 	movups 0xc8(%rsp),%xmm0
  1851af:	00 
  1851b0:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  1851b5:	48 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%rax
  1851bc:	00 
  1851bd:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  1851c4:	00 
  1851c5:	c6 44 24 68 05       	movb   $0x5,0x68(%rsp)
  1851ca:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  1851cf:	48 8b 05 da 1f 4c 00 	mov    0x4c1fda(%rip),%rax        # 6471b0 <_DYNAMIC+0x350>
  1851d6:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  1851db:	48 8d 3d 6c 62 ee ff 	lea    -0x119d94(%rip),%rdi        # 6b44e <anon.e8c9979099957ea97e14e3734d806e91.11.llvm.12140543486298777174+0xf3>
  1851e2:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  1851e7:	ff 15 ab 24 4c 00    	call   *0x4c24ab(%rip)        # 647698 <_DYNAMIC+0x838>
  1851ed:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1851f2:	e8 49 e0 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  1851f7:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  1851fc:	48 85 f6             	test   %rsi,%rsi
  1851ff:	74 10                	je     185211 <allocation_pmu_probe::main+0x15a1>
  185201:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  185206:	ba 01 00 00 00       	mov    $0x1,%edx
  18520b:	ff 15 bf 1e 4c 00    	call   *0x4c1ebf(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185211:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  185218:	00 
  185219:	48 85 f6             	test   %rsi,%rsi
  18521c:	74 13                	je     185231 <allocation_pmu_probe::main+0x15c1>
  18521e:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  185225:	00 
  185226:	ba 01 00 00 00       	mov    $0x1,%edx
  18522b:	ff 15 9f 1e 4c 00    	call   *0x4c1e9f(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185231:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  185238:	00 
  185239:	48 85 f6             	test   %rsi,%rsi
  18523c:	74 13                	je     185251 <allocation_pmu_probe::main+0x15e1>
  18523e:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  185245:	00 
  185246:	ba 01 00 00 00       	mov    $0x1,%edx
  18524b:	ff 15 7f 1e 4c 00    	call   *0x4c1e7f(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185251:	41 b6 01             	mov    $0x1,%r14b
  185254:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  18525b:	00 
  18525c:	e8 5f da ff ff       	call   182cc0 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  185261:	48 8d bc 24 78 08 00 	lea    0x878(%rsp),%rdi
  185268:	00 
  185269:	e8 d2 df ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  18526e:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  185275:	00 
  185276:	e8 25 cf ff ff       	call   1821a0 <core::ptr::drop_glue::<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>>
  18527b:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  185282:	00 
  185283:	e8 f8 e0 ff ff       	call   183380 <core::ptr::drop_glue::<behavior_core::semantic::module::Module>>
  185288:	48 8b b4 24 b0 01 00 	mov    0x1b0(%rsp),%rsi
  18528f:	00 
  185290:	48 85 f6             	test   %rsi,%rsi
  185293:	74 13                	je     1852a8 <allocation_pmu_probe::main+0x1638>
  185295:	ba 01 00 00 00       	mov    $0x1,%edx
  18529a:	48 8b bc 24 98 01 00 	mov    0x198(%rsp),%rdi
  1852a1:	00 
  1852a2:	ff 15 28 1e 4c 00    	call   *0x4c1e28(%rip)        # 6470d0 <_DYNAMIC+0x270>
  1852a8:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  1852af:	00 
  1852b0:	48 85 f6             	test   %rsi,%rsi
  1852b3:	74 13                	je     1852c8 <allocation_pmu_probe::main+0x1658>
  1852b5:	48 8b bc 24 08 02 00 	mov    0x208(%rsp),%rdi
  1852bc:	00 
  1852bd:	ba 01 00 00 00       	mov    $0x1,%edx
  1852c2:	ff 15 08 1e 4c 00    	call   *0x4c1e08(%rip)        # 6470d0 <_DYNAMIC+0x270>
  1852c8:	48 8b b4 24 18 02 00 	mov    0x218(%rsp),%rsi
  1852cf:	00 
  1852d0:	48 85 f6             	test   %rsi,%rsi
  1852d3:	74 13                	je     1852e8 <allocation_pmu_probe::main+0x1678>
  1852d5:	48 8b bc 24 20 02 00 	mov    0x220(%rsp),%rdi
  1852dc:	00 
  1852dd:	ba 01 00 00 00       	mov    $0x1,%edx
  1852e2:	ff 15 e8 1d 4c 00    	call   *0x4c1de8(%rip)        # 6470d0 <_DYNAMIC+0x270>
  1852e8:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
  1852ef:	00 
  1852f0:	48 85 f6             	test   %rsi,%rsi
  1852f3:	74 13                	je     185308 <allocation_pmu_probe::main+0x1698>
  1852f5:	ba 01 00 00 00       	mov    $0x1,%edx
  1852fa:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  185301:	00 
  185302:	ff 15 c8 1d 4c 00    	call   *0x4c1dc8(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185308:	8b 7c 24 64          	mov    0x64(%rsp),%edi
  18530c:	48 8b 1d 8d 23 4c 00 	mov    0x4c238d(%rip),%rbx        # 6476a0 <close@GLIBC_2.2.5>
  185313:	ff d3                	call   *%rbx
  185315:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  185319:	ff d3                	call   *%rbx
  18531b:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
  185322:	00 
  185323:	4c 8b b4 24 08 01 00 	mov    0x108(%rsp),%r14
  18532a:	00 
  18532b:	4d 85 f6             	test   %r14,%r14
  18532e:	74 2f                	je     18535f <allocation_pmu_probe::main+0x16ef>
  185330:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  185334:	4c 8b 25 95 1d 4c 00 	mov    0x4c1d95(%rip),%r12        # 6470d0 <_DYNAMIC+0x270>
  18533b:	eb 0c                	jmp    185349 <allocation_pmu_probe::main+0x16d9>
  18533d:	0f 1f 00             	nopl   (%rax)
  185340:	49 83 c7 18          	add    $0x18,%r15
  185344:	49 ff ce             	dec    %r14
  185347:	74 16                	je     18535f <allocation_pmu_probe::main+0x16ef>
  185349:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  18534d:	48 85 f6             	test   %rsi,%rsi
  185350:	74 ee                	je     185340 <allocation_pmu_probe::main+0x16d0>
  185352:	49 8b 3f             	mov    (%r15),%rdi
  185355:	ba 01 00 00 00       	mov    $0x1,%edx
  18535a:	41 ff d4             	call   *%r12
  18535d:	eb e1                	jmp    185340 <allocation_pmu_probe::main+0x16d0>
  18535f:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  185366:	00 
  185367:	48 85 c0             	test   %rax,%rax
  18536a:	74 16                	je     185382 <allocation_pmu_probe::main+0x1712>
  18536c:	48 c1 e0 03          	shl    $0x3,%rax
  185370:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  185374:	ba 08 00 00 00       	mov    $0x8,%edx
  185379:	48 89 df             	mov    %rbx,%rdi
  18537c:	ff 15 4e 1d 4c 00    	call   *0x4c1d4e(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185382:	48 81 c4 18 0e 00 00 	add    $0xe18,%rsp
  185389:	5b                   	pop    %rbx
  18538a:	41 5c                	pop    %r12
  18538c:	41 5d                	pop    %r13
  18538e:	41 5e                	pop    %r14
  185390:	41 5f                	pop    %r15
  185392:	5d                   	pop    %rbp
  185393:	c3                   	ret
  185394:	80 c2 d0             	add    $0xd0,%dl
  185397:	31 c0                	xor    %eax,%eax
  185399:	80 fa 0a             	cmp    $0xa,%dl
  18539c:	14 01                	adc    $0x1,%al
  18539e:	88 84 24 78 02 00 00 	mov    %al,0x278(%rsp)
  1853a5:	4c 8d 05 0c 81 4b 00 	lea    0x4b810c(%rip),%r8        # 63d4b8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x18>
  1853ac:	eb 18                	jmp    1853c6 <allocation_pmu_probe::main+0x1756>
  1853ae:	80 c2 d0             	add    $0xd0,%dl
  1853b1:	31 c0                	xor    %eax,%eax
  1853b3:	80 fa 0a             	cmp    $0xa,%dl
  1853b6:	14 01                	adc    $0x1,%al
  1853b8:	88 84 24 78 02 00 00 	mov    %al,0x278(%rsp)
  1853bf:	4c 8d 05 0a 81 4b 00 	lea    0x4b810a(%rip),%r8        # 63d4d0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x30>
  1853c6:	48 8d 3d 7c fb ee ff 	lea    -0x110484(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1853cd:	48 8d 0d 6c 83 4b 00 	lea    0x4b836c(%rip),%rcx        # 63d740 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x2a0>
  1853d4:	be 2b 00 00 00       	mov    $0x2b,%esi
  1853d9:	48 89 da             	mov    %rbx,%rdx
  1853dc:	ff 15 de 1d 4c 00    	call   *0x4c1dde(%rip)        # 6471c0 <_DYNAMIC+0x360>
  1853e2:	e9 36 05 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1853e7:	45 31 f6             	xor    %r14d,%r14d
  1853ea:	48 8d 15 87 81 4b 00 	lea    0x4b8187(%rip),%rdx        # 63d578 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xd8>
  1853f1:	4c 8d 0d 68 82 4b 00 	lea    0x4b8268(%rip),%r9        # 63d660 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1c0>
  1853f8:	31 ff                	xor    %edi,%edi
  1853fa:	48 89 c6             	mov    %rax,%rsi
  1853fd:	31 c9                	xor    %ecx,%ecx
  1853ff:	e8 16 0f 00 00       	call   18631a <core::panicking::assert_failed::<serde_json::value::Value, &str>>
  185404:	e9 14 05 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185409:	48 8d 0d ba fa ee ff 	lea    -0x110546(%rip),%rcx        # 74eca <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x111>
  185410:	4c 8d 0d e9 81 4b 00 	lea    0x4b81e9(%rip),%r9        # 63d600 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x160>
  185417:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
  18541c:	48 8d 94 24 10 01 00 	lea    0x110(%rsp),%rdx
  185423:	00 
  185424:	41 b8 45 00 00 00    	mov    $0x45,%r8d
  18542a:	31 ff                	xor    %edi,%edi
  18542c:	e8 b6 0e 00 00       	call   1862e7 <core::panicking::assert_failed::<alloc::vec::Vec<u8>, alloc::vec::Vec<u8>>>
  185431:	e9 e7 04 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185436:	48 8d 15 23 f2 ee ff 	lea    -0x110ddd(%rip),%rdx        # 74660 <anon.f0ce8b4fff13ea61fcd41c9a7fbb4fc9.42.llvm.102737351613787692+0x10>
  18543d:	48 8d 0d cc fa ee ff 	lea    -0x110534(%rip),%rcx        # 74f10 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x157>
  185444:	4c 8d 0d 2d 82 4b 00 	lea    0x4b822d(%rip),%r9        # 63d678 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1d8>
  18544b:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  185452:	00 
  185453:	41 b8 65 00 00 00    	mov    $0x65,%r8d
  185459:	31 ff                	xor    %edi,%edi
  18545b:	ff 15 47 22 4c 00    	call   *0x4c2247(%rip)        # 6476a8 <_DYNAMIC+0x848>
  185461:	e9 b7 04 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185466:	48 8b 84 24 a8 08 00 	mov    0x8a8(%rsp),%rax
  18546d:	00 
  18546e:	48 89 84 24 40 06 00 	mov    %rax,0x640(%rsp)
  185475:	00 
  185476:	48 8d 3d cc fa ee ff 	lea    -0x110534(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  18547d:	48 8d 0d 5c 82 4b 00 	lea    0x4b825c(%rip),%rcx        # 63d6e0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  185484:	4c 8d 05 75 80 4b 00 	lea    0x4b8075(%rip),%r8        # 63d500 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x60>
  18548b:	48 8d 94 24 40 06 00 	lea    0x640(%rsp),%rdx
  185492:	00 
  185493:	be 2b 00 00 00       	mov    $0x2b,%esi
  185498:	ff 15 22 1d 4c 00    	call   *0x4c1d22(%rip)        # 6471c0 <_DYNAMIC+0x360>
  18549e:	e9 7a 04 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1854a3:	48 8b 84 24 a8 08 00 	mov    0x8a8(%rsp),%rax
  1854aa:	00 
  1854ab:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  1854b2:	00 
  1854b3:	48 8d 3d 8f fa ee ff 	lea    -0x110571(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1854ba:	48 8d 0d 1f 82 4b 00 	lea    0x4b821f(%rip),%rcx        # 63d6e0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  1854c1:	4c 8d 05 50 80 4b 00 	lea    0x4b8050(%rip),%r8        # 63d518 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x78>
  1854c8:	48 8d 94 24 78 02 00 	lea    0x278(%rsp),%rdx
  1854cf:	00 
  1854d0:	be 2b 00 00 00       	mov    $0x2b,%esi
  1854d5:	ff 15 e5 1c 4c 00    	call   *0x4c1ce5(%rip)        # 6471c0 <_DYNAMIC+0x360>
  1854db:	e9 3d 04 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1854e0:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
  1854e7:	00 
  1854e8:	48 89 84 24 a0 08 00 	mov    %rax,0x8a0(%rsp)
  1854ef:	00 
  1854f0:	48 8d 3d 52 fa ee ff 	lea    -0x1105ae(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1854f7:	48 8d 0d e2 81 4b 00 	lea    0x4b81e2(%rip),%rcx        # 63d6e0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  1854fe:	4c 8d 05 2b 80 4b 00 	lea    0x4b802b(%rip),%r8        # 63d530 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x90>
  185505:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  18550c:	00 
  18550d:	be 2b 00 00 00       	mov    $0x2b,%esi
  185512:	ff 15 a8 1c 4c 00    	call   *0x4c1ca8(%rip)        # 6471c0 <_DYNAMIC+0x360>
  185518:	e9 00 04 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  18551d:	0f 10 84 24 d0 02 00 	movups 0x2d0(%rsp),%xmm0
  185524:	00 
  185525:	0f 29 84 24 f0 08 00 	movaps %xmm0,0x8f0(%rsp)
  18552c:	00 
  18552d:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  185534:	00 
  185535:	0f 29 84 24 e0 08 00 	movaps %xmm0,0x8e0(%rsp)
  18553c:	00 
  18553d:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  185544:	00 
  185545:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  18554c:	00 
  18554d:	0f 10 94 24 a0 02 00 	movups 0x2a0(%rsp),%xmm2
  185554:	00 
  185555:	0f 10 9c 24 b0 02 00 	movups 0x2b0(%rsp),%xmm3
  18555c:	00 
  18555d:	0f 29 9c 24 d0 08 00 	movaps %xmm3,0x8d0(%rsp)
  185564:	00 
  185565:	0f 29 94 24 c0 08 00 	movaps %xmm2,0x8c0(%rsp)
  18556c:	00 
  18556d:	0f 29 8c 24 b0 08 00 	movaps %xmm1,0x8b0(%rsp)
  185574:	00 
  185575:	0f 29 84 24 a0 08 00 	movaps %xmm0,0x8a0(%rsp)
  18557c:	00 
  18557d:	48 8d 3d c5 f9 ee ff 	lea    -0x11063b(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  185584:	48 8d 0d 75 81 4b 00 	lea    0x4b8175(%rip),%rcx        # 63d700 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  18558b:	4c 8d 05 b6 7f 4b 00 	lea    0x4b7fb6(%rip),%r8        # 63d548 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xa8>
  185592:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  185599:	00 
  18559a:	be 2b 00 00 00       	mov    $0x2b,%esi
  18559f:	ff 15 1b 1c 4c 00    	call   *0x4c1c1b(%rip)        # 6471c0 <_DYNAMIC+0x360>
  1855a5:	e9 73 03 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1855aa:	0f 10 84 24 d0 02 00 	movups 0x2d0(%rsp),%xmm0
  1855b1:	00 
  1855b2:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  1855b9:	00 
  1855ba:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  1855c1:	00 
  1855c2:	0f 29 84 24 80 06 00 	movaps %xmm0,0x680(%rsp)
  1855c9:	00 
  1855ca:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  1855d1:	00 
  1855d2:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  1855d9:	00 
  1855da:	0f 10 94 24 a0 02 00 	movups 0x2a0(%rsp),%xmm2
  1855e1:	00 
  1855e2:	0f 10 9c 24 b0 02 00 	movups 0x2b0(%rsp),%xmm3
  1855e9:	00 
  1855ea:	0f 29 9c 24 70 06 00 	movaps %xmm3,0x670(%rsp)
  1855f1:	00 
  1855f2:	0f 29 94 24 60 06 00 	movaps %xmm2,0x660(%rsp)
  1855f9:	00 
  1855fa:	0f 29 8c 24 50 06 00 	movaps %xmm1,0x650(%rsp)
  185601:	00 
  185602:	0f 29 84 24 40 06 00 	movaps %xmm0,0x640(%rsp)
  185609:	00 
  18560a:	48 8d 3d 38 f9 ee ff 	lea    -0x1106c8(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  185611:	48 8d 0d e8 80 4b 00 	lea    0x4b80e8(%rip),%rcx        # 63d700 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  185618:	4c 8d 05 41 7f 4b 00 	lea    0x4b7f41(%rip),%r8        # 63d560 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xc0>
  18561f:	48 8d 94 24 40 06 00 	lea    0x640(%rsp),%rdx
  185626:	00 
  185627:	be 2b 00 00 00       	mov    $0x2b,%esi
  18562c:	ff 15 8e 1b 4c 00    	call   *0x4c1b8e(%rip)        # 6471c0 <_DYNAMIC+0x360>
  185632:	e9 e6 02 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185637:	41 b6 01             	mov    $0x1,%r14b
  18563a:	48 8d 3d 47 7f 4b 00 	lea    0x4b7f47(%rip),%rdi        # 63d588 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xe8>
  185641:	ff 15 b1 1a 4c 00    	call   *0x4c1ab1(%rip)        # 6470f8 <_DYNAMIC+0x298>
  185647:	e9 d1 02 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  18564c:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  185653:	00 
  185654:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  18565b:	00 
  18565c:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  185663:	00 
  185664:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  18566b:	00 
  18566c:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  185671:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  185676:	0f 10 94 24 88 00 00 	movups 0x88(%rsp),%xmm2
  18567d:	00 
  18567e:	0f 10 9c 24 98 00 00 	movups 0x98(%rsp),%xmm3
  185685:	00 
  185686:	0f 29 9c 24 60 01 00 	movaps %xmm3,0x160(%rsp)
  18568d:	00 
  18568e:	0f 29 94 24 50 01 00 	movaps %xmm2,0x150(%rsp)
  185695:	00 
  185696:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
  18569d:	00 
  18569e:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  1856a5:	00 
  1856a6:	48 8d 3d 9c f8 ee ff 	lea    -0x110764(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1856ad:	48 8d 0d 4c 80 4b 00 	lea    0x4b804c(%rip),%rcx        # 63d700 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  1856b4:	4c 8d 05 e5 7e 4b 00 	lea    0x4b7ee5(%rip),%r8        # 63d5a0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x100>
  1856bb:	48 8d 94 24 30 01 00 	lea    0x130(%rsp),%rdx
  1856c2:	00 
  1856c3:	be 2b 00 00 00       	mov    $0x2b,%esi
  1856c8:	ff 15 f2 1a 4c 00    	call   *0x4c1af2(%rip)        # 6471c0 <_DYNAMIC+0x360>
  1856ce:	e9 4a 02 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1856d3:	48 8d 3d 12 f8 ee ff 	lea    -0x1107ee(%rip),%rdi        # 74eec <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x133>
  1856da:	48 8d 15 67 7f 4b 00 	lea    0x4b7f67(%rip),%rdx        # 63d648 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1a8>
  1856e1:	be 24 00 00 00       	mov    $0x24,%esi
  1856e6:	ff 15 04 1a 4c 00    	call   *0x4c1a04(%rip)        # 6470f0 <_DYNAMIC+0x290>
  1856ec:	e9 2c 02 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1856f1:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
  1856f8:	00 
  1856f9:	48 8d 15 88 ee ee ff 	lea    -0x111178(%rip),%rdx        # 74588 <anon.61e42543b9444b059ba09fd35f806a5e.153.llvm.4887216051044481709+0x8>
  185700:	4c 8d 0d 29 7f 4b 00 	lea    0x4b7f29(%rip),%r9        # 63d630 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x190>
  185707:	31 ff                	xor    %edi,%edi
  185709:	31 c9                	xor    %ecx,%ecx
  18570b:	ff 15 9f 1f 4c 00    	call   *0x4c1f9f(%rip)        # 6476b0 <_DYNAMIC+0x850>
  185711:	e9 07 02 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185716:	4c 8d 0d b3 7e 4b 00 	lea    0x4b7eb3(%rip),%r9        # 63d5d0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x130>
  18571d:	48 8d b4 24 c0 01 00 	lea    0x1c0(%rsp),%rsi
  185724:	00 
  185725:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  18572a:	31 ff                	xor    %edi,%edi
  18572c:	31 c9                	xor    %ecx,%ecx
  18572e:	ff 15 74 1f 4c 00    	call   *0x4c1f74(%rip)        # 6476a8 <_DYNAMIC+0x848>
  185734:	e9 e4 01 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185739:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  18573e:	48 8d 3d 04 f8 ee ff 	lea    -0x1107fc(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  185745:	48 8d 0d 94 7f 4b 00 	lea    0x4b7f94(%rip),%rcx        # 63d6e0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  18574c:	4c 8d 05 95 7e 4b 00 	lea    0x4b7e95(%rip),%r8        # 63d5e8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x148>
  185753:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  185758:	be 2b 00 00 00       	mov    $0x2b,%esi
  18575d:	ff 15 5d 1a 4c 00    	call   *0x4c1a5d(%rip)        # 6471c0 <_DYNAMIC+0x360>
  185763:	e9 b5 01 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185768:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  18576d:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  185772:	48 8d 3d d0 f7 ee ff 	lea    -0x110830(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  185779:	48 8d 0d a0 7f 4b 00 	lea    0x4b7fa0(%rip),%rcx        # 63d720 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  185780:	4c 8d 05 91 7e 4b 00 	lea    0x4b7e91(%rip),%r8        # 63d618 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x178>
  185787:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  18578c:	be 2b 00 00 00       	mov    $0x2b,%esi
  185791:	ff 15 29 1a 4c 00    	call   *0x4c1a29(%rip)        # 6471c0 <_DYNAMIC+0x360>
  185797:	e9 81 01 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  18579c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  1857a1:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  1857a6:	48 8d 3d 9c f7 ee ff 	lea    -0x110864(%rip),%rdi        # 74f49 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1857ad:	48 8d 0d 6c 7f 4b 00 	lea    0x4b7f6c(%rip),%rcx        # 63d720 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  1857b4:	4c 8d 05 5d 7e 4b 00 	lea    0x4b7e5d(%rip),%r8        # 63d618 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x178>
  1857bb:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  1857c0:	be 2b 00 00 00       	mov    $0x2b,%esi
  1857c5:	ff 15 f5 19 4c 00    	call   *0x4c19f5(%rip)        # 6471c0 <_DYNAMIC+0x360>
  1857cb:	e9 4d 01 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1857d0:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  1857d5:	b9 01 00 00 00       	mov    $0x1,%ecx
  1857da:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  1857e0:	48 89 ee             	mov    %rbp,%rsi
  1857e3:	48 89 da             	mov    %rbx,%rdx
  1857e6:	e8 c5 3b 00 00       	call   1893b0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  1857eb:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  1857f0:	e9 bb ef ff ff       	jmp    1847b0 <allocation_pmu_probe::main+0xb40>
  1857f5:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  1857fa:	ba 01 00 00 00       	mov    $0x1,%edx
  1857ff:	b9 01 00 00 00       	mov    $0x1,%ecx
  185804:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  18580a:	e8 a1 3b 00 00       	call   1893b0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  18580f:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  185814:	e9 d0 ef ff ff       	jmp    1847e9 <allocation_pmu_probe::main+0xb79>
  185819:	48 8d 3d e0 71 4b 00 	lea    0x4b71e0(%rip),%rdi        # 63ca00 <anon.a0b181daf0748f92ee2071baa91061bb.7.llvm.16326187416535719487>
  185820:	ff 15 d2 18 4c 00    	call   *0x4c18d2(%rip)        # 6470f8 <_DYNAMIC+0x298>
  185826:	e9 f2 00 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  18582b:	ba 01 00 00 00       	mov    $0x1,%edx
  185830:	b9 01 00 00 00       	mov    $0x1,%ecx
  185835:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  18583b:	48 89 df             	mov    %rbx,%rdi
  18583e:	e8 6d 3b 00 00       	call   1893b0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  185843:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  185847:	e9 36 f2 ff ff       	jmp    184a82 <allocation_pmu_probe::main+0xe12>
  18584c:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  185851:	ba 01 00 00 00       	mov    $0x1,%edx
  185856:	b9 01 00 00 00       	mov    $0x1,%ecx
  18585b:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  185861:	e8 4a 3b 00 00       	call   1893b0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  185866:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  18586b:	e9 9c ef ff ff       	jmp    18480c <allocation_pmu_probe::main+0xb9c>
  185870:	b0 01                	mov    $0x1,%al
  185872:	e9 27 fb ff ff       	jmp    18539e <allocation_pmu_probe::main+0x172e>
  185877:	b0 01                	mov    $0x1,%al
  185879:	e9 3a fb ff ff       	jmp    1853b8 <allocation_pmu_probe::main+0x1748>
  18587e:	bf 01 00 00 00       	mov    $0x1,%edi
  185883:	4c 89 fe             	mov    %r15,%rsi
  185886:	ff 15 bc 18 4c 00    	call   *0x4c18bc(%rip)        # 647148 <_DYNAMIC+0x2e8>
  18588c:	e9 8c 00 00 00       	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185891:	48 8d 3d 98 71 4b 00 	lea    0x4b7198(%rip),%rdi        # 63ca30 <anon.a0b181daf0748f92ee2071baa91061bb.9.llvm.16326187416535719487>
  185898:	ff 15 5a 18 4c 00    	call   *0x4c185a(%rip)        # 6470f8 <_DYNAMIC+0x298>
  18589e:	eb 7d                	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1858a0:	48 8d 3d ca f5 ee ff 	lea    -0x110a36(%rip),%rdi        # 74e71 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xb8>
  1858a7:	48 8d 15 3a 7c 4b 00 	lea    0x4b7c3a(%rip),%rdx        # 63d4e8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x48>
  1858ae:	be 34 00 00 00       	mov    $0x34,%esi
  1858b3:	ff 15 37 18 4c 00    	call   *0x4c1837(%rip)        # 6470f0 <_DYNAMIC+0x290>
  1858b9:	eb 62                	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1858bb:	bf 01 00 00 00       	mov    $0x1,%edi
  1858c0:	be 03 00 00 00       	mov    $0x3,%esi
  1858c5:	ff 15 7d 18 4c 00    	call   *0x4c187d(%rip)        # 647148 <_DYNAMIC+0x2e8>
  1858cb:	eb 50                	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1858cd:	bf 01 00 00 00       	mov    $0x1,%edi
  1858d2:	be 06 00 00 00       	mov    $0x6,%esi
  1858d7:	ff 15 6b 18 4c 00    	call   *0x4c186b(%rip)        # 647148 <_DYNAMIC+0x2e8>
  1858dd:	eb 3e                	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1858df:	bf 01 00 00 00       	mov    $0x1,%edi
  1858e4:	4c 89 f6             	mov    %r14,%rsi
  1858e7:	ff 15 5b 18 4c 00    	call   *0x4c185b(%rip)        # 647148 <_DYNAMIC+0x2e8>
  1858ed:	eb 2e                	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  1858ef:	bf 01 00 00 00       	mov    $0x1,%edi
  1858f4:	be 0e 00 00 00       	mov    $0xe,%esi
  1858f9:	ff 15 49 18 4c 00    	call   *0x4c1849(%rip)        # 647148 <_DYNAMIC+0x2e8>
  1858ff:	eb 1c                	jmp    18591d <allocation_pmu_probe::main+0x1cad>
  185901:	31 c0                	xor    %eax,%eax
  185903:	e9 96 fa ff ff       	jmp    18539e <allocation_pmu_probe::main+0x172e>
  185908:	31 c0                	xor    %eax,%eax
  18590a:	e9 a9 fa ff ff       	jmp    1853b8 <allocation_pmu_probe::main+0x1748>
  18590f:	bf 01 00 00 00       	mov    $0x1,%edi
  185914:	4c 89 f6             	mov    %r14,%rsi
  185917:	ff 15 2b 18 4c 00    	call   *0x4c182b(%rip)        # 647148 <_DYNAMIC+0x2e8>
  18591d:	0f 0b                	ud2
  18591f:	48 89 c3             	mov    %rax,%rbx
  185922:	e9 d5 02 00 00       	jmp    185bfc <allocation_pmu_probe::main+0x1f8c>
  185927:	e9 c4 00 00 00       	jmp    1859f0 <allocation_pmu_probe::main+0x1d80>
  18592c:	48 89 c3             	mov    %rax,%rbx
  18592f:	e9 15 03 00 00       	jmp    185c49 <allocation_pmu_probe::main+0x1fd9>
  185934:	48 89 c3             	mov    %rax,%rbx
  185937:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  18593c:	e8 ff d8 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  185941:	e9 9c 02 00 00       	jmp    185be2 <allocation_pmu_probe::main+0x1f72>
  185946:	e9 41 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  18594b:	e9 3c 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  185950:	e9 37 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  185955:	e9 32 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  18595a:	e9 2d 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  18595f:	48 89 c3             	mov    %rax,%rbx
  185962:	e9 51 01 00 00       	jmp    185ab8 <allocation_pmu_probe::main+0x1e48>
  185967:	e9 20 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  18596c:	48 89 c3             	mov    %rax,%rbx
  18596f:	e9 5e 01 00 00       	jmp    185ad2 <allocation_pmu_probe::main+0x1e62>
  185974:	e9 13 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  185979:	48 89 c3             	mov    %rax,%rbx
  18597c:	be 0b 00 00 00       	mov    $0xb,%esi
  185981:	e9 51 01 00 00       	jmp    185ad7 <allocation_pmu_probe::main+0x1e67>
  185986:	e9 01 01 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  18598b:	48 89 c3             	mov    %rax,%rbx
  18598e:	be 04 00 00 00       	mov    $0x4,%esi
  185993:	e9 3f 01 00 00       	jmp    185ad7 <allocation_pmu_probe::main+0x1e67>
  185998:	e9 ef 00 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  18599d:	e9 ea 00 00 00       	jmp    185a8c <allocation_pmu_probe::main+0x1e1c>
  1859a2:	48 89 c3             	mov    %rax,%rbx
  1859a5:	e9 5f 02 00 00       	jmp    185c09 <allocation_pmu_probe::main+0x1f99>
  1859aa:	48 89 c3             	mov    %rax,%rbx
  1859ad:	eb 0d                	jmp    1859bc <allocation_pmu_probe::main+0x1d4c>
  1859af:	48 89 c3             	mov    %rax,%rbx
  1859b2:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1859b7:	e8 84 d8 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  1859bc:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  1859c1:	e8 ea 0b fd ff       	call   1565b0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  1859c6:	45 31 f6             	xor    %r14d,%r14d
  1859c9:	e9 50 02 00 00       	jmp    185c1e <allocation_pmu_probe::main+0x1fae>
  1859ce:	48 89 c3             	mov    %rax,%rbx
  1859d1:	e9 64 01 00 00       	jmp    185b3a <allocation_pmu_probe::main+0x1eca>
  1859d6:	eb 6f                	jmp    185a47 <allocation_pmu_probe::main+0x1dd7>
  1859d8:	48 89 c3             	mov    %rax,%rbx
  1859db:	be 03 00 00 00       	mov    $0x3,%esi
  1859e0:	ba 01 00 00 00       	mov    $0x1,%edx
  1859e5:	4c 89 f7             	mov    %r14,%rdi
  1859e8:	ff 15 e2 16 4c 00    	call   *0x4c16e2(%rip)        # 6470d0 <_DYNAMIC+0x270>
  1859ee:	eb 5a                	jmp    185a4a <allocation_pmu_probe::main+0x1dda>
  1859f0:	48 89 c3             	mov    %rax,%rbx
  1859f3:	e9 5e 02 00 00       	jmp    185c56 <allocation_pmu_probe::main+0x1fe6>
  1859f8:	48 89 c3             	mov    %rax,%rbx
  1859fb:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  185a02:	00 
  185a03:	e8 e8 cb ff ff       	call   1825f0 <core::ptr::drop_glue::<behavior_store::memory::InMemoryBackend>>
  185a08:	e9 49 02 00 00       	jmp    185c56 <allocation_pmu_probe::main+0x1fe6>
  185a0d:	48 89 c3             	mov    %rax,%rbx
  185a10:	4d 85 f6             	test   %r14,%r14
  185a13:	0f 84 57 02 00 00    	je     185c70 <allocation_pmu_probe::main+0x2000>
  185a19:	4c 89 e7             	mov    %r12,%rdi
  185a1c:	4c 89 f6             	mov    %r14,%rsi
  185a1f:	ba 01 00 00 00       	mov    $0x1,%edx
  185a24:	ff 15 a6 16 4c 00    	call   *0x4c16a6(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185a2a:	e9 41 02 00 00       	jmp    185c70 <allocation_pmu_probe::main+0x2000>
  185a2f:	48 89 c3             	mov    %rax,%rbx
  185a32:	e9 39 02 00 00       	jmp    185c70 <allocation_pmu_probe::main+0x2000>
  185a37:	48 89 c3             	mov    %rax,%rbx
  185a3a:	e9 51 02 00 00       	jmp    185c90 <allocation_pmu_probe::main+0x2020>
  185a3f:	48 89 c3             	mov    %rax,%rbx
  185a42:	e9 59 01 00 00       	jmp    185ba0 <allocation_pmu_probe::main+0x1f30>
  185a47:	48 89 c3             	mov    %rax,%rbx
  185a4a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  185a4f:	e8 ec 14 fd ff       	call   156f40 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value> as core::ops::drop::Drop>::drop>
  185a54:	e9 f8 00 00 00       	jmp    185b51 <allocation_pmu_probe::main+0x1ee1>
  185a59:	48 89 c3             	mov    %rax,%rbx
  185a5c:	49 8d 46 ff          	lea    -0x1(%r14),%rax
  185a60:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  185a64:	0f 87 92 01 00 00    	ja     185bfc <allocation_pmu_probe::main+0x1f8c>
  185a6a:	4c 89 f6             	mov    %r14,%rsi
  185a6d:	ba 01 00 00 00       	mov    $0x1,%edx
  185a72:	4c 89 e7             	mov    %r12,%rdi
  185a75:	e9 7c 01 00 00       	jmp    185bf6 <allocation_pmu_probe::main+0x1f86>
  185a7a:	48 89 c3             	mov    %rax,%rbx
  185a7d:	e9 e1 01 00 00       	jmp    185c63 <allocation_pmu_probe::main+0x1ff3>
  185a82:	e9 58 01 00 00       	jmp    185bdf <allocation_pmu_probe::main+0x1f6f>
  185a87:	e9 53 01 00 00       	jmp    185bdf <allocation_pmu_probe::main+0x1f6f>
  185a8c:	48 89 c3             	mov    %rax,%rbx
  185a8f:	eb 54                	jmp    185ae5 <allocation_pmu_probe::main+0x1e75>
  185a91:	48 89 c3             	mov    %rax,%rbx
  185a94:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  185a99:	e8 02 d7 ff ff       	call   1831a0 <core::ptr::drop_glue::<serde_json::error::Error>>
  185a9e:	e9 3f 01 00 00       	jmp    185be2 <allocation_pmu_probe::main+0x1f72>
  185aa3:	ff 15 57 16 4c 00    	call   *0x4c1657(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185aa9:	0f 0b                	ud2
  185aab:	48 89 c3             	mov    %rax,%rbx
  185aae:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  185ab3:	e8 e8 d6 ff ff       	call   1831a0 <core::ptr::drop_glue::<serde_json::error::Error>>
  185ab8:	be 08 00 00 00       	mov    $0x8,%esi
  185abd:	eb 18                	jmp    185ad7 <allocation_pmu_probe::main+0x1e67>
  185abf:	ff 15 3b 16 4c 00    	call   *0x4c163b(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185ac5:	48 89 c3             	mov    %rax,%rbx
  185ac8:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  185acd:	e8 ce d6 ff ff       	call   1831a0 <core::ptr::drop_glue::<serde_json::error::Error>>
  185ad2:	be 09 00 00 00       	mov    $0x9,%esi
  185ad7:	ba 01 00 00 00       	mov    $0x1,%edx
  185adc:	4c 89 ef             	mov    %r13,%rdi
  185adf:	ff 15 eb 15 4c 00    	call   *0x4c15eb(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185ae5:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  185aec:	00 
  185aed:	e8 4e 14 fd ff       	call   156f40 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value> as core::ops::drop::Drop>::drop>
  185af2:	e9 eb 00 00 00       	jmp    185be2 <allocation_pmu_probe::main+0x1f72>
  185af7:	ff 15 03 16 4c 00    	call   *0x4c1603(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185afd:	48 89 c3             	mov    %rax,%rbx
  185b00:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  185b05:	e8 36 d8 ff ff       	call   183340 <core::ptr::drop_glue::<core::io::error::Error>>
  185b0a:	e9 d3 00 00 00       	jmp    185be2 <allocation_pmu_probe::main+0x1f72>
  185b0f:	ff 15 eb 15 4c 00    	call   *0x4c15eb(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185b15:	48 89 c3             	mov    %rax,%rbx
  185b18:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  185b1f:	00 
  185b20:	e8 2b cf ff ff       	call   182a50 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  185b25:	e9 df 00 00 00       	jmp    185c09 <allocation_pmu_probe::main+0x1f99>
  185b2a:	48 89 c3             	mov    %rax,%rbx
  185b2d:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  185b34:	00 
  185b35:	e8 16 cf ff ff       	call   182a50 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  185b3a:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  185b41:	00 
  185b42:	e8 f9 d6 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  185b47:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  185b4c:	e8 ef d6 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  185b51:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  185b56:	e8 55 0a fd ff       	call   1565b0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  185b5b:	e9 e9 00 00 00       	jmp    185c49 <allocation_pmu_probe::main+0x1fd9>
  185b60:	48 89 c3             	mov    %rax,%rbx
  185b63:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  185b6a:	00 
  185b6b:	e8 e0 ce ff ff       	call   182a50 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  185b70:	e9 e1 00 00 00       	jmp    185c56 <allocation_pmu_probe::main+0x1fe6>
  185b75:	48 89 c3             	mov    %rax,%rbx
  185b78:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  185b7f:	00 
  185b80:	e8 bb d7 ff ff       	call   183340 <core::ptr::drop_glue::<core::io::error::Error>>
  185b85:	e9 06 01 00 00       	jmp    185c90 <allocation_pmu_probe::main+0x2020>
  185b8a:	ff 15 70 15 4c 00    	call   *0x4c1570(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185b90:	48 89 c3             	mov    %rax,%rbx
  185b93:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  185b9a:	00 
  185b9b:	e8 a0 d7 ff ff       	call   183340 <core::ptr::drop_glue::<core::io::error::Error>>
  185ba0:	41 bc 07 00 00 00    	mov    $0x7,%r12d
  185ba6:	e9 f7 00 00 00       	jmp    185ca2 <allocation_pmu_probe::main+0x2032>
  185bab:	ff 15 4f 15 4c 00    	call   *0x4c154f(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185bb1:	48 89 c3             	mov    %rax,%rbx
  185bb4:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  185bbb:	00 
  185bbc:	e8 7f d7 ff ff       	call   183340 <core::ptr::drop_glue::<core::io::error::Error>>
  185bc1:	41 bc 07 00 00 00    	mov    $0x7,%r12d
  185bc7:	4c 8b b4 24 00 01 00 	mov    0x100(%rsp),%r14
  185bce:	00 
  185bcf:	e9 1b 01 00 00       	jmp    185cef <allocation_pmu_probe::main+0x207f>
  185bd4:	ff 15 26 15 4c 00    	call   *0x4c1526(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185bda:	48 89 c3             	mov    %rax,%rbx
  185bdd:	eb 1d                	jmp    185bfc <allocation_pmu_probe::main+0x1f8c>
  185bdf:	48 89 c3             	mov    %rax,%rbx
  185be2:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  185be7:	48 85 f6             	test   %rsi,%rsi
  185bea:	74 10                	je     185bfc <allocation_pmu_probe::main+0x1f8c>
  185bec:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  185bf1:	ba 01 00 00 00       	mov    $0x1,%edx
  185bf6:	ff 15 d4 14 4c 00    	call   *0x4c14d4(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185bfc:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  185c03:	00 
  185c04:	e8 a7 c9 ff ff       	call   1825b0 <core::ptr::drop_glue::<behavior_store::store::Committed>>
  185c09:	41 b6 01             	mov    $0x1,%r14b
  185c0c:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  185c13:	00 
  185c14:	e8 a7 d0 ff ff       	call   182cc0 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  185c19:	eb 03                	jmp    185c1e <allocation_pmu_probe::main+0x1fae>
  185c1b:	48 89 c3             	mov    %rax,%rbx
  185c1e:	48 8d bc 24 78 08 00 	lea    0x878(%rsp),%rdi
  185c25:	00 
  185c26:	e8 15 d6 ff ff       	call   183240 <core::ptr::drop_glue::<serde_json::value::Value>>
  185c2b:	48 83 bc 24 40 06 00 	cmpq   $0xffffffffffffffff,0x640(%rsp)
  185c32:	00 ff 
  185c34:	0f 94 c0             	sete   %al
  185c37:	41 08 c6             	or     %al,%r14b
  185c3a:	75 0d                	jne    185c49 <allocation_pmu_probe::main+0x1fd9>
  185c3c:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  185c43:	00 
  185c44:	e8 77 d0 ff ff       	call   182cc0 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  185c49:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  185c50:	00 
  185c51:	e8 4a c5 ff ff       	call   1821a0 <core::ptr::drop_glue::<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>>
  185c56:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  185c5d:	00 
  185c5e:	e8 1d d7 ff ff       	call   183380 <core::ptr::drop_glue::<behavior_core::semantic::module::Module>>
  185c63:	48 8d bc 24 e8 01 00 	lea    0x1e8(%rsp),%rdi
  185c6a:	00 
  185c6b:	e8 f0 c8 ff ff       	call   182560 <core::ptr::drop_glue::<allocation_pmu_probe::fixture::Case>>
  185c70:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
  185c77:	00 
  185c78:	48 85 f6             	test   %rsi,%rsi
  185c7b:	74 13                	je     185c90 <allocation_pmu_probe::main+0x2020>
  185c7d:	48 8b bc 24 18 01 00 	mov    0x118(%rsp),%rdi
  185c84:	00 
  185c85:	ba 01 00 00 00       	mov    $0x1,%edx
  185c8a:	ff 15 40 14 4c 00    	call   *0x4c1440(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185c90:	8b 7c 24 64          	mov    0x64(%rsp),%edi
  185c94:	ff 15 06 1a 4c 00    	call   *0x4c1a06(%rip)        # 6476a0 <close@GLIBC_2.2.5>
  185c9a:	4c 8b a4 24 08 01 00 	mov    0x108(%rsp),%r12
  185ca1:	00 
  185ca2:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  185ca6:	ff 15 f4 19 4c 00    	call   *0x4c19f4(%rip)        # 6476a0 <close@GLIBC_2.2.5>
  185cac:	eb 09                	jmp    185cb7 <allocation_pmu_probe::main+0x2047>
  185cae:	ff 15 4c 14 4c 00    	call   *0x4c144c(%rip)        # 647100 <_DYNAMIC+0x2a0>
  185cb4:	48 89 c3             	mov    %rax,%rbx
  185cb7:	4c 8b b4 24 00 01 00 	mov    0x100(%rsp),%r14
  185cbe:	00 
  185cbf:	4d 85 e4             	test   %r12,%r12
  185cc2:	75 2b                	jne    185cef <allocation_pmu_probe::main+0x207f>
  185cc4:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  185ccb:	00 
  185ccc:	48 85 c0             	test   %rax,%rax
  185ccf:	74 16                	je     185ce7 <allocation_pmu_probe::main+0x2077>
  185cd1:	48 c1 e0 03          	shl    $0x3,%rax
  185cd5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  185cd9:	ba 08 00 00 00       	mov    $0x8,%edx
  185cde:	4c 89 f7             	mov    %r14,%rdi
  185ce1:	ff 15 e9 13 4c 00    	call   *0x4c13e9(%rip)        # 6470d0 <_DYNAMIC+0x270>
  185ce7:	48 89 df             	mov    %rbx,%rdi
  185cea:	e8 01 59 4b 00       	call   63b5f0 <_Unwind_Resume@plt>
  185cef:	4d 8d 7e 08          	lea    0x8(%r14),%r15
  185cf3:	4c 8b 2d d6 13 4c 00 	mov    0x4c13d6(%rip),%r13        # 6470d0 <_DYNAMIC+0x270>
  185cfa:	eb 0d                	jmp    185d09 <allocation_pmu_probe::main+0x2099>
  185cfc:	0f 1f 40 00          	nopl   0x0(%rax)
  185d00:	49 83 c7 18          	add    $0x18,%r15
  185d04:	49 ff cc             	dec    %r12
  185d07:	74 bb                	je     185cc4 <allocation_pmu_probe::main+0x2054>
  185d09:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  185d0d:	48 85 f6             	test   %rsi,%rsi
  185d10:	74 ee                	je     185d00 <allocation_pmu_probe::main+0x2090>
  185d12:	49 8b 3f             	mov    (%r15),%rdi
  185d15:	ba 01 00 00 00       	mov    $0x1,%edx
  185d1a:	41 ff d5             	call   *%r13
  185d1d:	eb e1                	jmp    185d00 <allocation_pmu_probe::main+0x2090>
  185d1f:	cc                   	int3
