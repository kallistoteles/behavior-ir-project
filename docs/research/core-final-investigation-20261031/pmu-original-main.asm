
/tmp/core-final-pmu-binaries-20261101/exec00:     file format elf64-x86-64


Disassembly of section .text:

00000000001818a0 <allocation_pmu_probe::main>:
  1818a0:	55                   	push   %rbp
  1818a1:	41 57                	push   %r15
  1818a3:	41 56                	push   %r14
  1818a5:	41 55                	push   %r13
  1818a7:	41 54                	push   %r12
  1818a9:	53                   	push   %rbx
  1818aa:	48 81 ec 18 0e 00 00 	sub    $0xe18,%rsp
  1818b1:	48 8d 9c 24 78 02 00 	lea    0x278(%rsp),%rbx
  1818b8:	00 
  1818b9:	48 89 df             	mov    %rbx,%rdi
  1818bc:	ff 15 6e 34 4c 00    	call   *0x4c346e(%rip)        # 644d30 <_DYNAMIC+0x818>
  1818c2:	48 c7 84 24 98 02 00 	movq   $0x1,0x298(%rsp)
  1818c9:	00 01 00 00 00 
  1818ce:	48 8d bc 24 f8 00 00 	lea    0xf8(%rsp),%rdi
  1818d5:	00 
  1818d6:	48 89 de             	mov    %rbx,%rsi
  1818d9:	e8 72 89 fe ff       	call   16a250 <<alloc::vec::Vec<alloc::string::String> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<alloc::string::String, core::iter::adapters::skip::Skip<std::env::Args>>>::from_iter>
  1818de:	4c 8b a4 24 08 01 00 	mov    0x108(%rsp),%r12
  1818e5:	00 
  1818e6:	4c 89 a4 24 78 02 00 	mov    %r12,0x278(%rsp)
  1818ed:	00 
  1818ee:	49 83 fc 07          	cmp    $0x7,%r12
  1818f2:	0f 85 6e 17 00 00    	jne    183066 <allocation_pmu_probe::main+0x17c6>
  1818f8:	4c 8b bc 24 00 01 00 	mov    0x100(%rsp),%r15
  1818ff:	00 
  181900:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  181904:	49 8b 77 10          	mov    0x10(%r15),%rsi
  181908:	48 83 fe 01          	cmp    $0x1,%rsi
  18190c:	74 0e                	je     18191c <allocation_pmu_probe::main+0x7c>
  18190e:	48 85 f6             	test   %rsi,%rsi
  181911:	0f 84 1a 1c 00 00    	je     183531 <allocation_pmu_probe::main+0x1c91>
  181917:	0f b6 11             	movzbl (%rcx),%edx
  18191a:	eb 17                	jmp    181933 <allocation_pmu_probe::main+0x93>
  18191c:	0f b6 11             	movzbl (%rcx),%edx
  18191f:	b0 01                	mov    $0x1,%al
  181921:	83 fa 2b             	cmp    $0x2b,%edx
  181924:	0f 84 a4 16 00 00    	je     182fce <allocation_pmu_probe::main+0x172e>
  18192a:	83 fa 2d             	cmp    $0x2d,%edx
  18192d:	0f 84 9b 16 00 00    	je     182fce <allocation_pmu_probe::main+0x172e>
  181933:	31 c0                	xor    %eax,%eax
  181935:	80 fa 2b             	cmp    $0x2b,%dl
  181938:	0f 94 c0             	sete   %al
  18193b:	48 89 f2             	mov    %rsi,%rdx
  18193e:	48 29 c2             	sub    %rax,%rdx
  181941:	48 01 c1             	add    %rax,%rcx
  181944:	48 f7 d8             	neg    %rax
  181947:	48 83 fa 11          	cmp    $0x11,%rdx
  18194b:	73 3a                	jae    181987 <allocation_pmu_probe::main+0xe7>
  18194d:	48 85 d2             	test   %rdx,%rdx
  181950:	0f 84 7d 00 00 00    	je     1819d3 <allocation_pmu_probe::main+0x133>
  181956:	48 01 c6             	add    %rax,%rsi
  181959:	48 f7 de             	neg    %rsi
  18195c:	31 c0                	xor    %eax,%eax
  18195e:	31 d2                	xor    %edx,%edx
  181960:	0f b6 3c 11          	movzbl (%rcx,%rdx,1),%edi
  181964:	83 c7 d0             	add    $0xffffffd0,%edi
  181967:	83 ff 09             	cmp    $0x9,%edi
  18196a:	0f 87 30 1b 00 00    	ja     1834a0 <allocation_pmu_probe::main+0x1c00>
  181970:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  181974:	89 ff                	mov    %edi,%edi
  181976:	48 8d 04 47          	lea    (%rdi,%rax,2),%rax
  18197a:	48 ff c2             	inc    %rdx
  18197d:	48 89 f7             	mov    %rsi,%rdi
  181980:	48 01 d7             	add    %rdx,%rdi
  181983:	75 db                	jne    181960 <allocation_pmu_probe::main+0xc0>
  181985:	eb 4e                	jmp    1819d5 <allocation_pmu_probe::main+0x135>
  181987:	48 01 c6             	add    %rax,%rsi
  18198a:	48 f7 de             	neg    %rsi
  18198d:	31 c0                	xor    %eax,%eax
  18198f:	bf 0a 00 00 00       	mov    $0xa,%edi
  181994:	45 31 c0             	xor    %r8d,%r8d
  181997:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  18199e:	00 00 
  1819a0:	48 89 f2             	mov    %rsi,%rdx
  1819a3:	4c 01 c2             	add    %r8,%rdx
  1819a6:	74 2d                	je     1819d5 <allocation_pmu_probe::main+0x135>
  1819a8:	48 f7 e7             	mul    %rdi
  1819ab:	42 0f b6 14 01       	movzbl (%rcx,%r8,1),%edx
  1819b0:	0f 80 0e 16 00 00    	jo     182fc4 <allocation_pmu_probe::main+0x1724>
  1819b6:	83 c2 d0             	add    $0xffffffd0,%edx
  1819b9:	83 fa 0a             	cmp    $0xa,%edx
  1819bc:	0f 83 de 1a 00 00    	jae    1834a0 <allocation_pmu_probe::main+0x1c00>
  1819c2:	89 d2                	mov    %edx,%edx
  1819c4:	49 ff c0             	inc    %r8
  1819c7:	48 01 d0             	add    %rdx,%rax
  1819ca:	73 d4                	jae    1819a0 <allocation_pmu_probe::main+0x100>
  1819cc:	b0 02                	mov    $0x2,%al
  1819ce:	e9 fb 15 00 00       	jmp    182fce <allocation_pmu_probe::main+0x172e>
  1819d3:	31 c0                	xor    %eax,%eax
  1819d5:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  1819dc:	00 
  1819dd:	49 8b 4f 20          	mov    0x20(%r15),%rcx
  1819e1:	49 8b 77 28          	mov    0x28(%r15),%rsi
  1819e5:	48 83 fe 01          	cmp    $0x1,%rsi
  1819e9:	74 0e                	je     1819f9 <allocation_pmu_probe::main+0x159>
  1819eb:	48 85 f6             	test   %rsi,%rsi
  1819ee:	0f 84 44 1b 00 00    	je     183538 <allocation_pmu_probe::main+0x1c98>
  1819f4:	0f b6 11             	movzbl (%rcx),%edx
  1819f7:	eb 17                	jmp    181a10 <allocation_pmu_probe::main+0x170>
  1819f9:	0f b6 11             	movzbl (%rcx),%edx
  1819fc:	b0 01                	mov    $0x1,%al
  1819fe:	83 fa 2b             	cmp    $0x2b,%edx
  181a01:	0f 84 e1 15 00 00    	je     182fe8 <allocation_pmu_probe::main+0x1748>
  181a07:	83 fa 2d             	cmp    $0x2d,%edx
  181a0a:	0f 84 d8 15 00 00    	je     182fe8 <allocation_pmu_probe::main+0x1748>
  181a10:	31 c0                	xor    %eax,%eax
  181a12:	80 fa 2b             	cmp    $0x2b,%dl
  181a15:	0f 94 c0             	sete   %al
  181a18:	48 89 f2             	mov    %rsi,%rdx
  181a1b:	48 29 c2             	sub    %rax,%rdx
  181a1e:	48 01 c1             	add    %rax,%rcx
  181a21:	48 f7 d8             	neg    %rax
  181a24:	48 83 fa 11          	cmp    $0x11,%rdx
  181a28:	73 44                	jae    181a6e <allocation_pmu_probe::main+0x1ce>
  181a2a:	48 85 d2             	test   %rdx,%rdx
  181a2d:	0f 84 86 00 00 00    	je     181ab9 <allocation_pmu_probe::main+0x219>
  181a33:	48 01 c6             	add    %rax,%rsi
  181a36:	48 f7 de             	neg    %rsi
  181a39:	45 31 ed             	xor    %r13d,%r13d
  181a3c:	31 c0                	xor    %eax,%eax
  181a3e:	66 90                	xchg   %ax,%ax
  181a40:	0f b6 14 01          	movzbl (%rcx,%rax,1),%edx
  181a44:	83 c2 d0             	add    $0xffffffd0,%edx
  181a47:	83 fa 09             	cmp    $0x9,%edx
  181a4a:	0f 87 57 1a 00 00    	ja     1834a7 <allocation_pmu_probe::main+0x1c07>
  181a50:	4a 8d 3c ad 00 00 00 	lea    0x0(,%r13,4),%rdi
  181a57:	00 
  181a58:	4c 01 ef             	add    %r13,%rdi
  181a5b:	89 d2                	mov    %edx,%edx
  181a5d:	4c 8d 2c 7a          	lea    (%rdx,%rdi,2),%r13
  181a61:	48 ff c0             	inc    %rax
  181a64:	48 89 f2             	mov    %rsi,%rdx
  181a67:	48 01 c2             	add    %rax,%rdx
  181a6a:	75 d4                	jne    181a40 <allocation_pmu_probe::main+0x1a0>
  181a6c:	eb 4e                	jmp    181abc <allocation_pmu_probe::main+0x21c>
  181a6e:	48 01 c6             	add    %rax,%rsi
  181a71:	48 f7 de             	neg    %rsi
  181a74:	45 31 ed             	xor    %r13d,%r13d
  181a77:	bf 0a 00 00 00       	mov    $0xa,%edi
  181a7c:	45 31 c0             	xor    %r8d,%r8d
  181a7f:	90                   	nop
  181a80:	48 89 f0             	mov    %rsi,%rax
  181a83:	4c 01 c0             	add    %r8,%rax
  181a86:	74 34                	je     181abc <allocation_pmu_probe::main+0x21c>
  181a88:	4c 89 e8             	mov    %r13,%rax
  181a8b:	48 f7 e7             	mul    %rdi
  181a8e:	42 0f b6 14 01       	movzbl (%rcx,%r8,1),%edx
  181a93:	0f 80 45 15 00 00    	jo     182fde <allocation_pmu_probe::main+0x173e>
  181a99:	83 c2 d0             	add    $0xffffffd0,%edx
  181a9c:	83 fa 0a             	cmp    $0xa,%edx
  181a9f:	0f 83 02 1a 00 00    	jae    1834a7 <allocation_pmu_probe::main+0x1c07>
  181aa5:	49 89 c5             	mov    %rax,%r13
  181aa8:	89 d0                	mov    %edx,%eax
  181aaa:	49 ff c0             	inc    %r8
  181aad:	49 01 c5             	add    %rax,%r13
  181ab0:	73 ce                	jae    181a80 <allocation_pmu_probe::main+0x1e0>
  181ab2:	b0 02                	mov    $0x2,%al
  181ab4:	e9 2f 15 00 00       	jmp    182fe8 <allocation_pmu_probe::main+0x1748>
  181ab9:	45 31 ed             	xor    %r13d,%r13d
  181abc:	49 8b 47 40          	mov    0x40(%r15),%rax
  181ac0:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  181ac7:	00 
  181ac8:	48 83 f8 05          	cmp    $0x5,%rax
  181acc:	0f 85 fe 19 00 00    	jne    1834d0 <allocation_pmu_probe::main+0x1c30>
  181ad2:	49 8b 57 38          	mov    0x38(%r15),%rdx
  181ad6:	b8 61 6c 6c 6f       	mov    $0x6f6c6c61,%eax
  181adb:	33 02                	xor    (%rdx),%eax
  181add:	0f b6 4a 04          	movzbl 0x4(%rdx),%ecx
  181ae1:	83 f1 63             	xor    $0x63,%ecx
  181ae4:	09 c1                	or     %eax,%ecx
  181ae6:	74 16                	je     181afe <allocation_pmu_probe::main+0x25e>
  181ae8:	b8 65 6d 70 74       	mov    $0x74706d65,%eax
  181aed:	33 02                	xor    (%rdx),%eax
  181aef:	0f b6 4a 04          	movzbl 0x4(%rdx),%ecx
  181af3:	83 f1 79             	xor    $0x79,%ecx
  181af6:	09 c1                	or     %eax,%ecx
  181af8:	0f 85 d2 19 00 00    	jne    1834d0 <allocation_pmu_probe::main+0x1c30>
  181afe:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  181b05:	00 
  181b06:	48 bb 00 00 00 00 b6 	movabs $0x1b600000000,%rbx
  181b0d:	01 00 00 
  181b10:	48 89 9c 24 78 02 00 	mov    %rbx,0x278(%rsp)
  181b17:	00 
  181b18:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
  181b1f:	00 00 00 00 
  181b23:	66 c7 84 24 84 02 00 	movw   $0x0,0x284(%rsp)
  181b2a:	00 00 00 
  181b2d:	c6 84 24 81 02 00 00 	movb   $0x1,0x281(%rsp)
  181b34:	01 
  181b35:	49 8b 57 50          	mov    0x50(%r15),%rdx
  181b39:	49 8b 4f 58          	mov    0x58(%r15),%rcx
  181b3d:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  181b44:	00 
  181b45:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  181b4c:	00 
  181b4d:	ff 15 45 31 4c 00    	call   *0x4c3145(%rip)        # 644c98 <_DYNAMIC+0x780>
  181b53:	83 bc 24 a0 08 00 00 	cmpl   $0x1,0x8a0(%rsp)
  181b5a:	01 
  181b5b:	0f 84 35 15 00 00    	je     183096 <allocation_pmu_probe::main+0x17f6>
  181b61:	8b 84 24 a4 08 00 00 	mov    0x8a4(%rsp),%eax
  181b68:	89 44 24 60          	mov    %eax,0x60(%rsp)
  181b6c:	48 89 9c 24 78 02 00 	mov    %rbx,0x278(%rsp)
  181b73:	00 
  181b74:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
  181b7b:	00 00 00 00 
  181b7f:	66 c7 84 24 84 02 00 	movw   $0x0,0x284(%rsp)
  181b86:	00 00 00 
  181b89:	c6 84 24 80 02 00 00 	movb   $0x1,0x280(%rsp)
  181b90:	01 
  181b91:	49 8b 57 68          	mov    0x68(%r15),%rdx
  181b95:	49 8b 4f 70          	mov    0x70(%r15),%rcx
  181b99:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  181ba0:	00 
  181ba1:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  181ba8:	00 
  181ba9:	ff 15 e9 30 4c 00    	call   *0x4c30e9(%rip)        # 644c98 <_DYNAMIC+0x780>
  181baf:	83 bc 24 a0 08 00 00 	cmpl   $0x1,0x8a0(%rsp)
  181bb6:	01 
  181bb7:	0f 84 16 15 00 00    	je     1830d3 <allocation_pmu_probe::main+0x1833>
  181bbd:	8b 84 24 a4 08 00 00 	mov    0x8a4(%rsp),%eax
  181bc4:	89 44 24 64          	mov    %eax,0x64(%rsp)
  181bc8:	49 8b b7 80 00 00 00 	mov    0x80(%r15),%rsi
  181bcf:	49 8b 97 88 00 00 00 	mov    0x88(%r15),%rdx
  181bd6:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  181bdd:	00 
  181bde:	ff 15 bc 30 4c 00    	call   *0x4c30bc(%rip)        # 644ca0 <_DYNAMIC+0x788>
  181be4:	48 83 bc 24 78 02 00 	cmpq   $0xffffffffffffffff,0x278(%rsp)
  181beb:	00 ff 
  181bed:	0f 84 1d 15 00 00    	je     183110 <allocation_pmu_probe::main+0x1870>
  181bf3:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
  181bfa:	00 
  181bfb:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  181c02:	00 
  181c03:	0f 10 84 24 78 02 00 	movups 0x278(%rsp),%xmm0
  181c0a:	00 
  181c0b:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  181c12:	00 
  181c13:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  181c1a:	00 
  181c1b:	48 89 84 24 a0 08 00 	mov    %rax,0x8a0(%rsp)
  181c22:	00 
  181c23:	48 8b 05 2e 2f 4c 00 	mov    0x4c2f2e(%rip),%rax        # 644b58 <_DYNAMIC+0x640>
  181c2a:	48 89 84 24 a8 08 00 	mov    %rax,0x8a8(%rsp)
  181c31:	00 
  181c32:	48 8d 35 21 c0 ee ff 	lea    -0x113fdf(%rip),%rsi        # 6dc5a <anon.9c2e91ffed01f0d41841dbf28fe36393.60.llvm.9527354877344579380+0x91>
  181c39:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  181c40:	00 
  181c41:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  181c48:	00 
  181c49:	ff 15 11 2c 4c 00    	call   *0x4c2c11(%rip)        # 644860 <_DYNAMIC+0x348>
  181c4f:	4c 8b b4 24 78 02 00 	mov    0x278(%rsp),%r14
  181c56:	00 
  181c57:	4c 8b a4 24 80 02 00 	mov    0x280(%rsp),%r12
  181c5e:	00 
  181c5f:	48 8b 9c 24 88 02 00 	mov    0x288(%rsp),%rbx
  181c66:	00 
  181c67:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  181c6e:	00 
  181c6f:	e8 3c 36 fe ff       	call   1652b0 <<allocation_pmu_probe::fixture::Case as core::default::Default>::default>
  181c74:	4c 89 b4 24 b0 01 00 	mov    %r14,0x1b0(%rsp)
  181c7b:	00 
  181c7c:	4c 89 b4 24 e8 01 00 	mov    %r14,0x1e8(%rsp)
  181c83:	00 
  181c84:	4c 89 a4 24 98 01 00 	mov    %r12,0x198(%rsp)
  181c8b:	00 
  181c8c:	4c 89 a4 24 f0 01 00 	mov    %r12,0x1f0(%rsp)
  181c93:	00 
  181c94:	48 89 9c 24 f8 01 00 	mov    %rbx,0x1f8(%rsp)
  181c9b:	00 
  181c9c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  181ca3:	00 
  181ca4:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  181cab:	00 
  181cac:	0f 10 84 24 c8 02 00 	movups 0x2c8(%rsp),%xmm0
  181cb3:	00 
  181cb4:	0f 11 84 24 38 02 00 	movups %xmm0,0x238(%rsp)
  181cbb:	00 
  181cbc:	0f 10 84 24 d8 02 00 	movups 0x2d8(%rsp),%xmm0
  181cc3:	00 
  181cc4:	0f 11 84 24 48 02 00 	movups %xmm0,0x248(%rsp)
  181ccb:	00 
  181ccc:	0f 10 84 24 e8 02 00 	movups 0x2e8(%rsp),%xmm0
  181cd3:	00 
  181cd4:	0f 11 84 24 58 02 00 	movups %xmm0,0x258(%rsp)
  181cdb:	00 
  181cdc:	0f 10 84 24 90 02 00 	movups 0x290(%rsp),%xmm0
  181ce3:	00 
  181ce4:	0f 11 84 24 00 02 00 	movups %xmm0,0x200(%rsp)
  181ceb:	00 
  181cec:	48 8b 84 24 a0 02 00 	mov    0x2a0(%rsp),%rax
  181cf3:	00 
  181cf4:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  181cfb:	00 
  181cfc:	0f 10 84 24 a8 02 00 	movups 0x2a8(%rsp),%xmm0
  181d03:	00 
  181d04:	0f 11 84 24 18 02 00 	movups %xmm0,0x218(%rsp)
  181d0b:	00 
  181d0c:	48 8b 84 24 b8 02 00 	mov    0x2b8(%rsp),%rax
  181d13:	00 
  181d14:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  181d1b:	00 
  181d1c:	4c 89 ac 24 68 02 00 	mov    %r13,0x268(%rsp)
  181d23:	00 
  181d24:	0f b6 84 24 00 03 00 	movzbl 0x300(%rsp),%eax
  181d2b:	00 
  181d2c:	88 84 24 70 02 00 00 	mov    %al,0x270(%rsp)
  181d33:	48 8b b4 24 78 02 00 	mov    0x278(%rsp),%rsi
  181d3a:	00 
  181d3b:	48 85 f6             	test   %rsi,%rsi
  181d3e:	74 13                	je     181d53 <allocation_pmu_probe::main+0x4b3>
  181d40:	48 8b bc 24 80 02 00 	mov    0x280(%rsp),%rdi
  181d47:	00 
  181d48:	ba 01 00 00 00       	mov    $0x1,%edx
  181d4d:	ff 15 35 2a 4c 00    	call   *0x4c2a35(%rip)        # 644788 <_DYNAMIC+0x270>
  181d53:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  181d5a:	00 
  181d5b:	48 8d b4 24 e8 01 00 	lea    0x1e8(%rsp),%rsi
  181d62:	00 
  181d63:	e8 18 24 fe ff       	call   164180 <allocation_pmu_probe::fixture::module>
  181d68:	48 c7 84 24 b8 08 00 	movq   $0xffffffffffffffff,0x8b8(%rsp)
  181d6f:	00 ff ff ff ff 
  181d74:	48 c7 84 24 c8 09 00 	movq   $0xffffffffffffffff,0x9c8(%rsp)
  181d7b:	00 ff ff ff ff 
  181d80:	48 c7 84 24 80 0a 00 	movq   $0x0,0xa80(%rsp)
  181d87:	00 00 00 00 00 
  181d8c:	0f 57 c0             	xorps  %xmm0,%xmm0
  181d8f:	0f 11 84 24 90 0a 00 	movups %xmm0,0xa90(%rsp)
  181d96:	00 
  181d97:	48 c7 84 24 a0 08 00 	movq   $0x0,0x8a0(%rsp)
  181d9e:	00 00 00 00 00 
  181da3:	48 c7 84 24 a8 08 00 	movq   $0x8,0x8a8(%rsp)
  181daa:	00 08 00 00 00 
  181daf:	48 c7 84 24 b0 08 00 	movq   $0x0,0x8b0(%rsp)
  181db6:	00 00 00 00 00 
  181dbb:	48 c7 84 24 f0 0a 00 	movq   $0x0,0xaf0(%rsp)
  181dc2:	00 00 00 00 00 
  181dc7:	0f 11 84 24 a8 0a 00 	movups %xmm0,0xaa8(%rsp)
  181dce:	00 
  181dcf:	0f 11 84 24 c0 0a 00 	movups %xmm0,0xac0(%rsp)
  181dd6:	00 
  181dd7:	0f 11 84 24 d8 0a 00 	movups %xmm0,0xad8(%rsp)
  181dde:	00 
  181ddf:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  181de6:	00 
  181de7:	48 8d b4 24 e8 01 00 	lea    0x1e8(%rsp),%rsi
  181dee:	00 
  181def:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  181df6:	00 
  181df7:	e8 94 2a fe ff       	call   164890 <allocation_pmu_probe::fixture::genesis>
  181dfc:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  181e03:	00 
  181e04:	48 8d b4 24 a0 08 00 	lea    0x8a0(%rsp),%rsi
  181e0b:	00 
  181e0c:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  181e13:	00 
  181e14:	48 8d 8c 24 40 06 00 	lea    0x640(%rsp),%rcx
  181e1b:	00 
  181e1c:	e8 0f 66 fb ff       	call   138430 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::create>
  181e21:	48 83 bc 24 78 02 00 	cmpq   $0xffffffffffffffff,0x278(%rsp)
  181e28:	00 ff 
  181e2a:	0f 84 1d 13 00 00    	je     18314d <allocation_pmu_probe::main+0x18ad>
  181e30:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  181e37:	00 
  181e38:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  181e3f:	00 
  181e40:	ba c8 03 00 00       	mov    $0x3c8,%edx
  181e45:	ff 15 4d 29 4c 00    	call   *0x4c294d(%rip)        # 644798 <memcpy@GLIBC_2.14>
  181e4b:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  181e52:	00 00 
  181e54:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  181e5b:	00 00 
  181e5d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  181e64:	00 00 
  181e66:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  181e6d:	00 00 
  181e6f:	ff 15 03 29 4c 00    	call   *0x4c2903(%rip)        # 644778 <_DYNAMIC+0x260>
  181e75:	bf 03 00 00 00       	mov    $0x3,%edi
  181e7a:	be 01 00 00 00       	mov    $0x1,%esi
  181e7f:	ff 15 fb 28 4c 00    	call   *0x4c28fb(%rip)        # 644780 <_DYNAMIC+0x268>
  181e85:	48 85 c0             	test   %rax,%rax
  181e88:	0f 84 5d 16 00 00    	je     1834eb <allocation_pmu_probe::main+0x1c4b>
  181e8e:	49 89 c6             	mov    %rax,%r14
  181e91:	c6 40 02 30          	movb   $0x30,0x2(%rax)
  181e95:	66 c7 00 69 64       	movw   $0x6469,(%rax)
  181e9a:	48 c7 84 24 30 01 00 	movq   $0x3,0x130(%rsp)
  181ea1:	00 03 00 00 00 
  181ea6:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  181ead:	00 
  181eae:	48 c7 84 24 40 01 00 	movq   $0x3,0x140(%rsp)
  181eb5:	00 03 00 00 00 
  181eba:	ff 15 b8 28 4c 00    	call   *0x4c28b8(%rip)        # 644778 <_DYNAMIC+0x260>
  181ec0:	bf 06 00 00 00       	mov    $0x6,%edi
  181ec5:	be 01 00 00 00       	mov    $0x1,%esi
  181eca:	ff 15 b0 28 4c 00    	call   *0x4c28b0(%rip)        # 644780 <_DYNAMIC+0x268>
  181ed0:	48 85 c0             	test   %rax,%rax
  181ed3:	0f 84 24 16 00 00    	je     1834fd <allocation_pmu_probe::main+0x1c5d>
  181ed9:	66 c7 40 04 5f 30    	movw   $0x305f,0x4(%rax)
  181edf:	c7 00 6e 65 77 30    	movl   $0x3077656e,(%rax)
  181ee5:	c6 84 24 78 02 00 00 	movb   $0x3,0x278(%rsp)
  181eec:	03 
  181eed:	48 c7 84 24 80 02 00 	movq   $0x6,0x280(%rsp)
  181ef4:	00 06 00 00 00 
  181ef9:	48 89 84 24 88 02 00 	mov    %rax,0x288(%rsp)
  181f00:	00 
  181f01:	48 c7 84 24 90 02 00 	movq   $0x6,0x290(%rsp)
  181f08:	00 06 00 00 00 
  181f0d:	4c 8d b4 24 40 06 00 	lea    0x640(%rsp),%r14
  181f14:	00 
  181f15:	48 8d 6c 24 20       	lea    0x20(%rsp),%rbp
  181f1a:	48 8d 9c 24 30 01 00 	lea    0x130(%rsp),%rbx
  181f21:	00 
  181f22:	48 8d 8c 24 78 02 00 	lea    0x278(%rsp),%rcx
  181f29:	00 
  181f2a:	4c 89 f7             	mov    %r14,%rdi
  181f2d:	48 89 ee             	mov    %rbp,%rsi
  181f30:	48 89 da             	mov    %rbx,%rdx
  181f33:	e8 58 b1 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  181f38:	80 bc 24 40 06 00 00 	cmpb   $0xff,0x640(%rsp)
  181f3f:	ff 
  181f40:	74 0d                	je     181f4f <allocation_pmu_probe::main+0x6af>
  181f42:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  181f49:	00 
  181f4a:	e8 21 ef ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  181f4f:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  181f54:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  181f59:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  181f5e:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  181f65:	00 
  181f66:	c6 44 24 68 05       	movb   $0x5,0x68(%rsp)
  181f6b:	48 c7 84 24 38 01 00 	movq   $0x0,0x138(%rsp)
  181f72:	00 00 00 00 00 
  181f77:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  181f7e:	00 00 00 00 00 
  181f83:	c6 84 24 30 01 00 00 	movb   $0x5,0x130(%rsp)
  181f8a:	05 
  181f8b:	48 c7 84 24 40 06 00 	movq   $0xffffffffffffffff,0x640(%rsp)
  181f92:	00 ff ff ff ff 
  181f97:	48 83 ec 08          	sub    $0x8,%rsp
  181f9b:	48 8d 05 59 31 ef ff 	lea    -0x10cea7(%rip),%rax        # 750fb <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xf2>
  181fa2:	4c 8d 54 24 70       	lea    0x70(%rsp),%r10
  181fa7:	48 8d 0d 47 31 ef ff 	lea    -0x10ceb9(%rip),%rcx        # 750f5 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xec>
  181fae:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
  181fb5:	00 
  181fb6:	48 8d b4 24 a8 08 00 	lea    0x8a8(%rsp),%rsi
  181fbd:	00 
  181fbe:	48 8d 94 24 70 0c 00 	lea    0xc70(%rsp),%rdx
  181fc5:	00 
  181fc6:	4c 8d 4c 24 10       	lea    0x10(%rsp),%r9
  181fcb:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  181fd1:	41 56                	push   %r14
  181fd3:	6a 14                	push   $0x14
  181fd5:	50                   	push   %rax
  181fd6:	53                   	push   %rbx
  181fd7:	41 52                	push   %r10
  181fd9:	e8 32 76 fb ff       	call   139610 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::evaluate>
  181fde:	48 83 c4 30          	add    $0x30,%rsp
  181fe2:	48 83 bc 24 78 02 00 	cmpq   $0xfffffffffffffffe,0x278(%rsp)
  181fe9:	00 fe 
  181feb:	0f 84 e9 11 00 00    	je     1831da <allocation_pmu_probe::main+0x193a>
  181ff1:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  181ff8:	00 
  181ff9:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  182000:	00 
  182001:	ba 58 02 00 00       	mov    $0x258,%edx
  182006:	ff 15 8c 27 4c 00    	call   *0x4c278c(%rip)        # 644798 <memcpy@GLIBC_2.14>
  18200c:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  182013:	00 
  182014:	e8 57 ee ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182019:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  18201e:	e8 4d ee ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182023:	45 31 f6             	xor    %r14d,%r14d
  182026:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  18202b:	e8 b0 21 fd ff       	call   1541e0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  182030:	48 8d 94 24 78 08 00 	lea    0x878(%rsp),%rdx
  182037:	00 
  182038:	45 31 f6             	xor    %r14d,%r14d
  18203b:	48 8d 3d cd 30 ef ff 	lea    -0x10cf33(%rip),%rdi        # 7510f <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x106>
  182042:	be 06 00 00 00       	mov    $0x6,%esi
  182047:	ff 15 63 28 4c 00    	call   *0x4c2863(%rip)        # 6448b0 <_DYNAMIC+0x398>
  18204d:	48 85 c0             	test   %rax,%rax
  182050:	75 07                	jne    182059 <allocation_pmu_probe::main+0x7b9>
  182052:	48 8b 05 5f 28 4c 00 	mov    0x4c285f(%rip),%rax        # 6448b8 <_DYNAMIC+0x3a0>
  182059:	80 38 03             	cmpb   $0x3,(%rax)
  18205c:	0f 85 b5 0f 00 00    	jne    183017 <allocation_pmu_probe::main+0x1777>
  182062:	48 83 78 18 05       	cmpq   $0x5,0x18(%rax)
  182067:	0f 85 aa 0f 00 00    	jne    183017 <allocation_pmu_probe::main+0x1777>
  18206d:	48 8b 48 10          	mov    0x10(%rax),%rcx
  182071:	ba 41 4c 4c 4f       	mov    $0x4f4c4c41,%edx
  182076:	33 11                	xor    (%rcx),%edx
  182078:	0f b6 49 04          	movzbl 0x4(%rcx),%ecx
  18207c:	83 f1 57             	xor    $0x57,%ecx
  18207f:	09 d1                	or     %edx,%ecx
  182081:	0f 85 90 0f 00 00    	jne    183017 <allocation_pmu_probe::main+0x1777>
  182087:	48 8b 84 24 40 06 00 	mov    0x640(%rsp),%rax
  18208e:	00 
  18208f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  182093:	0f 84 ce 11 00 00    	je     183267 <allocation_pmu_probe::main+0x19c7>
  182099:	48 8d b4 24 48 06 00 	lea    0x648(%rsp),%rsi
  1820a0:	00 
  1820a1:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  1820a8:	00 
  1820a9:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
  1820b0:	00 
  1820b1:	ba 30 02 00 00       	mov    $0x230,%edx
  1820b6:	ff 15 dc 26 4c 00    	call   *0x4c26dc(%rip)        # 644798 <memcpy@GLIBC_2.14>
  1820bc:	48 8d 8c 24 90 02 00 	lea    0x290(%rsp),%rcx
  1820c3:	00 
  1820c4:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  1820c9:	48 8d b4 24 a0 08 00 	lea    0x8a0(%rsp),%rsi
  1820d0:	00 
  1820d1:	48 8d 94 24 68 0c 00 	lea    0xc68(%rsp),%rdx
  1820d8:	00 
  1820d9:	4c 8d 84 24 78 02 00 	lea    0x278(%rsp),%r8
  1820e0:	00 
  1820e1:	48 89 df             	mov    %rbx,%rdi
  1820e4:	45 31 c9             	xor    %r9d,%r9d
  1820e7:	e8 14 79 fa ff       	call   129a00 <<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>::commit_impl>
  1820ec:	48 83 7c 24 68 ff    	cmpq   $0xffffffffffffffff,0x68(%rsp)
  1820f2:	0f 85 84 11 00 00    	jne    18327c <allocation_pmu_probe::main+0x19dc>
  1820f8:	0f 10 84 24 b0 00 00 	movups 0xb0(%rsp),%xmm0
  1820ff:	00 
  182100:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  182107:	00 
  182108:	0f 10 44 24 70       	movups 0x70(%rsp),%xmm0
  18210d:	0f 10 8c 24 80 00 00 	movups 0x80(%rsp),%xmm1
  182114:	00 
  182115:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  18211c:	00 
  18211d:	0f 10 9c 24 a0 00 00 	movups 0xa0(%rsp),%xmm3
  182124:	00 
  182125:	0f 29 9c 24 60 01 00 	movaps %xmm3,0x160(%rsp)
  18212c:	00 
  18212d:	0f 29 94 24 50 01 00 	movaps %xmm2,0x150(%rsp)
  182134:	00 
  182135:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
  18213c:	00 
  18213d:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  182144:	00 
  182145:	80 bc 24 78 01 00 00 	cmpb   $0x0,0x178(%rsp)
  18214c:	00 
  18214d:	0f 85 b0 11 00 00    	jne    183303 <allocation_pmu_probe::main+0x1a63>
  182153:	48 83 bc 24 60 01 00 	cmpq   $0x1,0x160(%rsp)
  18215a:	00 01 
  18215c:	0f 85 bf 11 00 00    	jne    183321 <allocation_pmu_probe::main+0x1a81>
  182162:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  182167:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
  18216c:	ba 01 00 00 00       	mov    $0x1,%edx
  182171:	e8 da 17 00 00       	call   183950 <allocation_pmu_probe::control>
  182176:	ff 15 bc 2b 4c 00    	call   *0x4c2bbc(%rip)        # 644d38 <_DYNAMIC+0x820>
  18217c:	48 89 84 24 c8 01 00 	mov    %rax,0x1c8(%rsp)
  182183:	00 
  182184:	89 94 24 d0 01 00 00 	mov    %edx,0x1d0(%rsp)
  18218b:	b8 61 6c 6c 6f       	mov    $0x6f6c6c61,%eax
  182190:	48 8b 8c 24 28 01 00 	mov    0x128(%rsp),%rcx
  182197:	00 
  182198:	33 01                	xor    (%rcx),%eax
  18219a:	0f b6 49 04          	movzbl 0x4(%rcx),%ecx
  18219e:	83 f1 63             	xor    $0x63,%ecx
  1821a1:	09 c1                	or     %eax,%ecx
  1821a3:	74 23                	je     1821c8 <allocation_pmu_probe::main+0x928>
  1821a5:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  1821ac:	00 
  1821ad:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  1821b4:	00 
  1821b5:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  1821ba:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  1821bf:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  1821c6:	eb 72                	jmp    18223a <allocation_pmu_probe::main+0x99a>
  1821c8:	4c 8b b4 24 20 01 00 	mov    0x120(%rsp),%r14
  1821cf:	00 
  1821d0:	4d 85 f6             	test   %r14,%r14
  1821d3:	74 2c                	je     182201 <allocation_pmu_probe::main+0x961>
  1821d5:	ff 15 9d 25 4c 00    	call   *0x4c259d(%rip)        # 644778 <_DYNAMIC+0x260>
  1821db:	be 01 00 00 00       	mov    $0x1,%esi
  1821e0:	4c 89 f7             	mov    %r14,%rdi
  1821e3:	ff 15 97 25 4c 00    	call   *0x4c2597(%rip)        # 644780 <_DYNAMIC+0x268>
  1821e9:	48 85 c0             	test   %rax,%rax
  1821ec:	75 18                	jne    182206 <allocation_pmu_probe::main+0x966>
  1821ee:	bf 01 00 00 00       	mov    $0x1,%edi
  1821f3:	4c 89 f6             	mov    %r14,%rsi
  1821f6:	ff 15 04 26 4c 00    	call   *0x4c2604(%rip)        # 644800 <_DYNAMIC+0x2e8>
  1821fc:	e9 4c 13 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  182201:	b8 01 00 00 00       	mov    $0x1,%eax
  182206:	4c 89 b4 24 e8 00 00 	mov    %r14,0xe8(%rsp)
  18220d:	00 
  18220e:	4c 89 74 24 68       	mov    %r14,0x68(%rsp)
  182213:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  182218:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  18221f:	00 00 
  182221:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  182226:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  18222b:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
  182230:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  182235:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  18223a:	48 8d bc 24 c8 01 00 	lea    0x1c8(%rsp),%rdi
  182241:	00 
  182242:	ff 15 f8 2a 4c 00    	call   *0x4c2af8(%rip)        # 644d40 <_DYNAMIC+0x828>
  182248:	89 d1                	mov    %edx,%ecx
  18224a:	ba 00 ca 9a 3b       	mov    $0x3b9aca00,%edx
  18224f:	48 f7 e2             	mul    %rdx
  182252:	89 c9                	mov    %ecx,%ecx
  182254:	48 01 c1             	add    %rax,%rcx
  182257:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  18225e:	00 
  18225f:	48 83 d2 00          	adc    $0x0,%rdx
  182263:	48 89 94 24 a8 01 00 	mov    %rdx,0x1a8(%rsp)
  18226a:	00 
  18226b:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  182270:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
  182275:	31 d2                	xor    %edx,%edx
  182277:	e8 d4 16 00 00       	call   183950 <allocation_pmu_probe::control>
  18227c:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  182280:	75 37                	jne    1822b9 <allocation_pmu_probe::main+0xa19>
  182282:	4c 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%r14
  182289:	00 
  18228a:	4d 85 f6             	test   %r14,%r14
  18228d:	74 22                	je     1822b1 <allocation_pmu_probe::main+0xa11>
  18228f:	ff 15 e3 24 4c 00    	call   *0x4c24e3(%rip)        # 644778 <_DYNAMIC+0x260>
  182295:	be 01 00 00 00       	mov    $0x1,%esi
  18229a:	4c 89 f7             	mov    %r14,%rdi
  18229d:	ff 15 dd 24 4c 00    	call   *0x4c24dd(%rip)        # 644780 <_DYNAMIC+0x268>
  1822a3:	48 85 c0             	test   %rax,%rax
  1822a6:	0f 84 93 12 00 00    	je     18353f <allocation_pmu_probe::main+0x1c9f>
  1822ac:	49 89 c4             	mov    %rax,%r12
  1822af:	eb 06                	jmp    1822b7 <allocation_pmu_probe::main+0xa17>
  1822b1:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  1822b7:	31 db                	xor    %ebx,%ebx
  1822b9:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
  1822be:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
  1822c3:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  1822c8:	4c 89 b4 24 c0 01 00 	mov    %r14,0x1c0(%rsp)
  1822cf:	00 
  1822d0:	ff 15 62 2a 4c 00    	call   *0x4c2a62(%rip)        # 644d38 <_DYNAMIC+0x820>
  1822d6:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
  1822dd:	00 
  1822de:	89 94 24 e0 01 00 00 	mov    %edx,0x1e0(%rsp)
  1822e5:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
  1822ea:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  1822ef:	0f b6 84 24 78 08 00 	movzbl 0x878(%rsp),%eax
  1822f6:	00 
  1822f7:	48 8d 0d 66 2d ef ff 	lea    -0x10d29a(%rip),%rcx        # 75064 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x5b>
  1822fe:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  182302:	48 01 c8             	add    %rcx,%rax
  182305:	ff e0                	jmp    *%rax
  182307:	bb 04 00 00 00       	mov    $0x4,%ebx
  18230c:	4c 8d 25 bd 13 ef ff 	lea    -0x10ec43(%rip),%r12        # 736d0 <anon.e8c9979099957ea97e14e3734d806e91.7.llvm.12140543486298777174>
  182313:	e9 b2 00 00 00       	jmp    1823ca <allocation_pmu_probe::main+0xb2a>
  182318:	48 8d b4 24 80 08 00 	lea    0x880(%rsp),%rsi
  18231f:	00 
  182320:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182325:	e8 d6 26 ff ff       	call   174a00 <<&mut serde_json::ser::Serializer<&mut alloc::vec::Vec<u8>> as serde_core::ser::Serializer>::collect_seq::<&alloc::vec::Vec<serde_json::value::Value>>>
  18232a:	eb 12                	jmp    18233e <allocation_pmu_probe::main+0xa9e>
  18232c:	48 8d bc 24 80 08 00 	lea    0x880(%rsp),%rdi
  182333:	00 
  182334:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  182339:	e8 72 3e ff ff       	call   1761b0 <<serde_json::number::Number as serde_core::ser::Serialize>::serialize::<&mut serde_json::ser::Serializer<&mut alloc::vec::Vec<u8>>>>
  18233e:	48 85 c0             	test   %rax,%rax
  182341:	0f 84 7a 03 00 00    	je     1826c1 <allocation_pmu_probe::main+0xe21>
  182347:	eb 31                	jmp    18237a <allocation_pmu_probe::main+0xada>
  182349:	48 8b 94 24 88 08 00 	mov    0x888(%rsp),%rdx
  182350:	00 
  182351:	48 8b 8c 24 90 08 00 	mov    0x890(%rsp),%rcx
  182358:	00 
  182359:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  18235e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182363:	e8 a8 0d ff ff       	call   173110 <serde_json::ser::format_escaped_str::<&mut alloc::vec::Vec<u8>, serde_json::ser::CompactFormatter>>
  182368:	48 85 c0             	test   %rax,%rax
  18236b:	0f 84 50 03 00 00    	je     1826c1 <allocation_pmu_probe::main+0xe21>
  182371:	48 89 c7             	mov    %rax,%rdi
  182374:	ff 15 ce 29 4c 00    	call   *0x4c29ce(%rip)        # 644d48 <_DYNAMIC+0x830>
  18237a:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  18237f:	48 8d 3d 13 2e ef ff 	lea    -0x10d1ed(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  182386:	48 8d 0d 63 8b 4b 00 	lea    0x4b8b63(%rip),%rcx        # 63aef0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  18238d:	4c 8d 05 f4 89 4b 00 	lea    0x4b89f4(%rip),%r8        # 63ad88 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x118>
  182394:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  182399:	be 2b 00 00 00       	mov    $0x2b,%esi
  18239e:	ff 15 d4 24 4c 00    	call   *0x4c24d4(%rip)        # 644878 <_DYNAMIC+0x360>
  1823a4:	e9 a4 11 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1823a9:	0f b6 9c 24 79 08 00 	movzbl 0x879(%rsp),%ebx
  1823b0:	00 
  1823b1:	48 8d 05 2c 13 ef ff 	lea    -0x10ecd4(%rip),%rax        # 736e4 <anon.1cb71ff3762624ae304e4a0523993dab.9.llvm.2568929261584004968>
  1823b8:	4c 8d 25 fd 2c ef ff 	lea    -0x10d303(%rip),%r12        # 750bc <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xb3>
  1823bf:	48 85 db             	test   %rbx,%rbx
  1823c2:	4c 0f 45 e0          	cmovne %rax,%r12
  1823c6:	48 83 f3 05          	xor    $0x5,%rbx
  1823ca:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  1823cf:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  1823d4:	48 29 e8             	sub    %rbp,%rax
  1823d7:	48 39 c3             	cmp    %rax,%rbx
  1823da:	0f 87 20 10 00 00    	ja     183400 <allocation_pmu_probe::main+0x1b60>
  1823e0:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  1823e5:	48 01 ef             	add    %rbp,%rdi
  1823e8:	4c 89 e6             	mov    %r12,%rsi
  1823eb:	48 89 da             	mov    %rbx,%rdx
  1823ee:	ff 15 a4 23 4c 00    	call   *0x4c23a4(%rip)        # 644798 <memcpy@GLIBC_2.14>
  1823f4:	48 01 dd             	add    %rbx,%rbp
  1823f7:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  1823fc:	e9 c0 02 00 00       	jmp    1826c1 <allocation_pmu_probe::main+0xe21>
  182401:	4c 8b a4 24 90 08 00 	mov    0x890(%rsp),%r12
  182408:	00 
  182409:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  18240e:	48 39 74 24 48       	cmp    %rsi,0x48(%rsp)
  182413:	0f 84 0c 10 00 00    	je     183425 <allocation_pmu_probe::main+0x1b85>
  182419:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  18241e:	c6 04 30 7b          	movb   $0x7b,(%rax,%rsi,1)
  182422:	48 ff c6             	inc    %rsi
  182425:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  18242a:	b0 01                	mov    $0x1,%al
  18242c:	4d 85 e4             	test   %r12,%r12
  18242f:	75 1e                	jne    18244f <allocation_pmu_probe::main+0xbaf>
  182431:	48 39 74 24 48       	cmp    %rsi,0x48(%rsp)
  182436:	0f 84 40 10 00 00    	je     18347c <allocation_pmu_probe::main+0x1bdc>
  18243c:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  182441:	c6 04 30 7d          	movb   $0x7d,(%rax,%rsi,1)
  182445:	48 ff c6             	inc    %rsi
  182448:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  18244d:	31 c0                	xor    %eax,%eax
  18244f:	4c 89 b4 24 e0 00 00 	mov    %r14,0xe0(%rsp)
  182456:	00 
  182457:	48 89 6c 24 68       	mov    %rbp,0x68(%rsp)
  18245c:	88 44 24 70          	mov    %al,0x70(%rsp)
  182460:	48 8b 8c 24 80 08 00 	mov    0x880(%rsp),%rcx
  182467:	00 
  182468:	4c 8b b4 24 88 08 00 	mov    0x888(%rsp),%r14
  18246f:	00 
  182470:	48 85 c9             	test   %rcx,%rcx
  182473:	0f 95 c2             	setne  %dl
  182476:	4c 0f 44 e1          	cmove  %rcx,%r12
  18247a:	31 ed                	xor    %ebp,%ebp
  18247c:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  182481:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  182488:	0f 1f 84 00 00 00 00 
  18248f:	00 
  182490:	49 83 ec 01          	sub    $0x1,%r12
  182494:	0f 82 f4 01 00 00    	jb     18268e <allocation_pmu_probe::main+0xdee>
  18249a:	f6 c2 01             	test   $0x1,%dl
  18249d:	0f 84 1e 10 00 00    	je     1834c1 <allocation_pmu_probe::main+0x1c21>
  1824a3:	48 85 ed             	test   %rbp,%rbp
  1824a6:	74 28                	je     1824d0 <allocation_pmu_probe::main+0xc30>
  1824a8:	0f b7 85 72 02 00 00 	movzwl 0x272(%rbp),%eax
  1824af:	49 39 c6             	cmp    %rax,%r14
  1824b2:	0f 83 c8 00 00 00    	jae    182580 <allocation_pmu_probe::main+0xce0>
  1824b8:	48 89 e8             	mov    %rbp,%rax
  1824bb:	4c 89 f2             	mov    %r14,%rdx
  1824be:	e9 e3 00 00 00       	jmp    1825a6 <allocation_pmu_probe::main+0xd06>
  1824c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1824ca:	84 00 00 00 00 00 
  1824d0:	4d 85 f6             	test   %r14,%r14
  1824d3:	74 38                	je     18250d <allocation_pmu_probe::main+0xc6d>
  1824d5:	4c 89 f0             	mov    %r14,%rax
  1824d8:	48 89 cd             	mov    %rcx,%rbp
  1824db:	48 83 e0 07          	and    $0x7,%rax
  1824df:	74 31                	je     182512 <allocation_pmu_probe::main+0xc72>
  1824e1:	31 c9                	xor    %ecx,%ecx
  1824e3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1824ea:	84 00 00 00 00 00 
  1824f0:	48 8b ad 78 02 00 00 	mov    0x278(%rbp),%rbp
  1824f7:	48 ff c1             	inc    %rcx
  1824fa:	48 39 c8             	cmp    %rcx,%rax
  1824fd:	75 f1                	jne    1824f0 <allocation_pmu_probe::main+0xc50>
  1824ff:	4c 89 f0             	mov    %r14,%rax
  182502:	48 29 c8             	sub    %rcx,%rax
  182505:	49 83 fe 08          	cmp    $0x8,%r14
  182509:	73 15                	jae    182520 <allocation_pmu_probe::main+0xc80>
  18250b:	eb 51                	jmp    18255e <allocation_pmu_probe::main+0xcbe>
  18250d:	48 89 cd             	mov    %rcx,%rbp
  182510:	eb 4c                	jmp    18255e <allocation_pmu_probe::main+0xcbe>
  182512:	4c 89 f0             	mov    %r14,%rax
  182515:	49 83 fe 08          	cmp    $0x8,%r14
  182519:	72 43                	jb     18255e <allocation_pmu_probe::main+0xcbe>
  18251b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  182520:	48 8b 8d 78 02 00 00 	mov    0x278(%rbp),%rcx
  182527:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18252e:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182535:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18253c:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182543:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18254a:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182551:	48 8b a9 78 02 00 00 	mov    0x278(%rcx),%rbp
  182558:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  18255c:	75 c2                	jne    182520 <allocation_pmu_probe::main+0xc80>
  18255e:	45 31 f6             	xor    %r14d,%r14d
  182561:	31 c9                	xor    %ecx,%ecx
  182563:	0f b7 85 72 02 00 00 	movzwl 0x272(%rbp),%eax
  18256a:	49 39 c6             	cmp    %rax,%r14
  18256d:	0f 82 45 ff ff ff    	jb     1824b8 <allocation_pmu_probe::main+0xc18>
  182573:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  18257a:	84 00 00 00 00 00 
  182580:	48 8b 85 60 01 00 00 	mov    0x160(%rbp),%rax
  182587:	48 85 c0             	test   %rax,%rax
  18258a:	0f 84 b9 0e 00 00    	je     183449 <allocation_pmu_probe::main+0x1ba9>
  182590:	48 ff c1             	inc    %rcx
  182593:	0f b7 95 70 02 00 00 	movzwl 0x270(%rbp),%edx
  18259a:	48 89 c5             	mov    %rax,%rbp
  18259d:	66 3b 90 72 02 00 00 	cmp    0x272(%rax),%dx
  1825a4:	73 da                	jae    182580 <allocation_pmu_probe::main+0xce0>
  1825a6:	48 85 c9             	test   %rcx,%rcx
  1825a9:	0f 84 91 00 00 00    	je     182640 <allocation_pmu_probe::main+0xda0>
  1825af:	48 8d 34 d0          	lea    (%rax,%rdx,8),%rsi
  1825b3:	48 81 c6 80 02 00 00 	add    $0x280,%rsi
  1825ba:	48 89 cf             	mov    %rcx,%rdi
  1825bd:	48 83 e7 07          	and    $0x7,%rdi
  1825c1:	0f 84 b9 00 00 00    	je     182680 <allocation_pmu_probe::main+0xde0>
  1825c7:	45 31 c0             	xor    %r8d,%r8d
  1825ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  1825d0:	48 8b 2e             	mov    (%rsi),%rbp
  1825d3:	48 8d b5 78 02 00 00 	lea    0x278(%rbp),%rsi
  1825da:	49 ff c0             	inc    %r8
  1825dd:	4c 39 c7             	cmp    %r8,%rdi
  1825e0:	75 ee                	jne    1825d0 <allocation_pmu_probe::main+0xd30>
  1825e2:	48 89 cf             	mov    %rcx,%rdi
  1825e5:	4c 29 c7             	sub    %r8,%rdi
  1825e8:	48 83 f9 08          	cmp    $0x8,%rcx
  1825ec:	72 43                	jb     182631 <allocation_pmu_probe::main+0xd91>
  1825ee:	66 90                	xchg   %ax,%ax
  1825f0:	48 8b 0e             	mov    (%rsi),%rcx
  1825f3:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  1825fa:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182601:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182608:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18260f:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  182616:	48 8b 89 78 02 00 00 	mov    0x278(%rcx),%rcx
  18261d:	48 8b a9 78 02 00 00 	mov    0x278(%rcx),%rbp
  182624:	48 8d b5 78 02 00 00 	lea    0x278(%rbp),%rsi
  18262b:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  18262f:	75 bf                	jne    1825f0 <allocation_pmu_probe::main+0xd50>
  182631:	45 31 f6             	xor    %r14d,%r14d
  182634:	eb 11                	jmp    182647 <allocation_pmu_probe::main+0xda7>
  182636:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  18263d:	00 00 00 
  182640:	4c 8d 72 01          	lea    0x1(%rdx),%r14
  182644:	48 89 c5             	mov    %rax,%rbp
  182647:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  18264b:	48 8d 34 c8          	lea    (%rax,%rcx,8),%rsi
  18264f:	48 81 c6 68 01 00 00 	add    $0x168,%rsi
  182656:	48 c1 e2 05          	shl    $0x5,%rdx
  18265a:	48 01 c2             	add    %rax,%rdx
  18265d:	48 89 df             	mov    %rbx,%rdi
  182660:	e8 ab 1f ff ff       	call   174610 <<serde_json::ser::Compound<&mut alloc::vec::Vec<u8>, serde_json::ser::CompactFormatter> as serde_core::ser::SerializeMap>::serialize_entry::<alloc::string::String, serde_json::value::Value>>
  182665:	b2 01                	mov    $0x1,%dl
  182667:	b9 00 00 00 00       	mov    $0x0,%ecx
  18266c:	48 85 c0             	test   %rax,%rax
  18266f:	0f 84 1b fe ff ff    	je     182490 <allocation_pmu_probe::main+0xbf0>
  182675:	e9 00 fd ff ff       	jmp    18237a <allocation_pmu_probe::main+0xada>
  18267a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  182680:	48 89 cf             	mov    %rcx,%rdi
  182683:	48 83 f9 08          	cmp    $0x8,%rcx
  182687:	72 a8                	jb     182631 <allocation_pmu_probe::main+0xd91>
  182689:	e9 62 ff ff ff       	jmp    1825f0 <allocation_pmu_probe::main+0xd50>
  18268e:	80 7c 24 70 00       	cmpb   $0x0,0x70(%rsp)
  182693:	4c 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14
  18269a:	00 
  18269b:	74 24                	je     1826c1 <allocation_pmu_probe::main+0xe21>
  18269d:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  1826a2:	48 8b 18             	mov    (%rax),%rbx
  1826a5:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  1826a9:	48 39 33             	cmp    %rsi,(%rbx)
  1826ac:	0f 84 a9 0d 00 00    	je     18345b <allocation_pmu_probe::main+0x1bbb>
  1826b2:	48 8b 43 08          	mov    0x8(%rbx),%rax
  1826b6:	c6 04 30 7d          	movb   $0x7d,(%rax,%rsi,1)
  1826ba:	48 ff c6             	inc    %rsi
  1826bd:	48 89 73 10          	mov    %rsi,0x10(%rbx)
  1826c1:	48 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%rdi
  1826c8:	00 
  1826c9:	ff 15 71 26 4c 00    	call   *0x4c2671(%rip)        # 644d40 <_DYNAMIC+0x828>
  1826cf:	89 d1                	mov    %edx,%ecx
  1826d1:	ba 00 ca 9a 3b       	mov    $0x3b9aca00,%edx
  1826d6:	48 f7 e2             	mul    %rdx
  1826d9:	49 89 d4             	mov    %rdx,%r12
  1826dc:	89 cb                	mov    %ecx,%ebx
  1826de:	48 01 c3             	add    %rax,%rbx
  1826e1:	49 83 d4 00          	adc    $0x0,%r12
  1826e5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  1826ea:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  1826ef:	49 39 c6             	cmp    %rax,%r14
  1826f2:	0f 85 4e 0c 00 00    	jne    183346 <allocation_pmu_probe::main+0x1aa6>
  1826f8:	49 8b bf 98 00 00 00 	mov    0x98(%r15),%rdi
  1826ff:	49 8b b7 a0 00 00 00 	mov    0xa0(%r15),%rsi
  182706:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  18270b:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  182710:	ff 15 92 25 4c 00    	call   *0x4c2592(%rip)        # 644ca8 <_DYNAMIC+0x790>
  182716:	48 85 c0             	test   %rax,%rax
  182719:	0f 85 4a 0c 00 00    	jne    183369 <allocation_pmu_probe::main+0x1ac9>
  18271f:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
  182726:	00 
  182727:	48 39 54 24 58       	cmp    %rdx,0x58(%rsp)
  18272c:	0f 85 07 09 00 00    	jne    183039 <allocation_pmu_probe::main+0x1799>
  182732:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
  182739:	00 
  18273a:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  18273f:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  182746:	00 
  182747:	ff 15 8b 20 4c 00    	call   *0x4c208b(%rip)        # 6447d8 <bcmp@GLIBC_2.2.5>
  18274d:	85 c0                	test   %eax,%eax
  18274f:	0f 85 e4 08 00 00    	jne    183039 <allocation_pmu_probe::main+0x1799>
  182755:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  18275c:	00 00 00 00 00 
  182761:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  182768:	00 00 00 00 00 
  18276d:	ff 15 05 20 4c 00    	call   *0x4c2005(%rip)        # 644778 <_DYNAMIC+0x260>
  182773:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  182779:	bf 01 00 00 00       	mov    $0x1,%edi
  18277e:	be 01 00 00 00       	mov    $0x1,%esi
  182783:	ff 15 f7 1f 4c 00    	call   *0x4c1ff7(%rip)        # 644780 <_DYNAMIC+0x268>
  182789:	48 85 c0             	test   %rax,%rax
  18278c:	0f 84 1c 0d 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182792:	c6 00 6e             	movb   $0x6e,(%rax)
  182795:	48 c7 44 24 08 01 00 	movq   $0x1,0x8(%rsp)
  18279c:	00 00 
  18279e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  1827a3:	48 c7 44 24 18 01 00 	movq   $0x1,0x18(%rsp)
  1827aa:	00 00 
  1827ac:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  1827b3:	00 
  1827b4:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  1827b9:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  1827c0:	00 00 
  1827c2:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  1827c7:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1827cc:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  1827d3:	00 
  1827d4:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  1827d9:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  1827de:	e8 ad a8 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  1827e3:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  1827e8:	74 0a                	je     1827f4 <allocation_pmu_probe::main+0xf54>
  1827ea:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1827ef:	e8 7c e6 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  1827f4:	ff 15 7e 1f 4c 00    	call   *0x4c1f7e(%rip)        # 644778 <_DYNAMIC+0x260>
  1827fa:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  182800:	bf 08 00 00 00       	mov    $0x8,%edi
  182805:	be 01 00 00 00       	mov    $0x1,%esi
  18280a:	ff 15 70 1f 4c 00    	call   *0x4c1f70(%rip)        # 644780 <_DYNAMIC+0x268>
  182810:	48 85 c0             	test   %rax,%rax
  182813:	0f 84 95 0c 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182819:	48 b9 63 6f 6d 6d 61 	movabs $0x73646e616d6d6f63,%rcx
  182820:	6e 64 73 
  182823:	48 89 08             	mov    %rcx,(%rax)
  182826:	48 c7 44 24 08 08 00 	movq   $0x8,0x8(%rsp)
  18282d:	00 00 
  18282f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182834:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  18283b:	00 00 
  18283d:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182842:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182849:	00 00 
  18284b:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
  182850:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182855:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  18285c:	00 
  18285d:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182862:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182867:	e8 24 a8 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  18286c:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182871:	74 0a                	je     18287d <allocation_pmu_probe::main+0xfdd>
  182873:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182878:	e8 f3 e5 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  18287d:	ff 15 f5 1e 4c 00    	call   *0x4c1ef5(%rip)        # 644778 <_DYNAMIC+0x260>
  182883:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  182889:	bf 04 00 00 00       	mov    $0x4,%edi
  18288e:	be 01 00 00 00       	mov    $0x1,%esi
  182893:	ff 15 e7 1e 4c 00    	call   *0x4c1ee7(%rip)        # 644780 <_DYNAMIC+0x268>
  182899:	48 85 c0             	test   %rax,%rax
  18289c:	0f 84 0c 0c 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  1828a2:	49 89 c5             	mov    %rax,%r13
  1828a5:	4c 89 f5             	mov    %r14,%rbp
  1828a8:	c7 00 6d 6f 64 65    	movl   $0x65646f6d,(%rax)
  1828ae:	48 c7 44 24 08 04 00 	movq   $0x4,0x8(%rsp)
  1828b5:	00 00 
  1828b7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  1828bc:	48 c7 44 24 18 04 00 	movq   $0x4,0x18(%rsp)
  1828c3:	00 00 
  1828c5:	ff 15 ad 1e 4c 00    	call   *0x4c1ead(%rip)        # 644778 <_DYNAMIC+0x260>
  1828cb:	be 01 00 00 00       	mov    $0x1,%esi
  1828d0:	4c 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%r14
  1828d7:	00 
  1828d8:	4c 89 f7             	mov    %r14,%rdi
  1828db:	ff 15 9f 1e 4c 00    	call   *0x4c1e9f(%rip)        # 644780 <_DYNAMIC+0x268>
  1828e1:	48 85 c0             	test   %rax,%rax
  1828e4:	0f 84 25 0c 00 00    	je     18350f <allocation_pmu_probe::main+0x1c6f>
  1828ea:	49 89 c7             	mov    %rax,%r15
  1828ed:	48 89 c7             	mov    %rax,%rdi
  1828f0:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  1828f7:	00 
  1828f8:	4c 89 f2             	mov    %r14,%rdx
  1828fb:	ff 15 97 1e 4c 00    	call   *0x4c1e97(%rip)        # 644798 <memcpy@GLIBC_2.14>
  182901:	c6 44 24 68 03       	movb   $0x3,0x68(%rsp)
  182906:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
  18290b:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
  182910:	4c 89 b4 24 80 00 00 	mov    %r14,0x80(%rsp)
  182917:	00 
  182918:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18291d:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182924:	00 
  182925:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  18292a:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  18292f:	e8 5c a7 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182934:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182939:	49 89 ee             	mov    %rbp,%r14
  18293c:	74 0a                	je     182948 <allocation_pmu_probe::main+0x10a8>
  18293e:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182943:	e8 28 e5 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182948:	ff 15 2a 1e 4c 00    	call   *0x4c1e2a(%rip)        # 644778 <_DYNAMIC+0x260>
  18294e:	41 bf 0b 00 00 00    	mov    $0xb,%r15d
  182954:	bf 0b 00 00 00       	mov    $0xb,%edi
  182959:	be 01 00 00 00       	mov    $0x1,%esi
  18295e:	ff 15 1c 1e 4c 00    	call   *0x4c1e1c(%rip)        # 644780 <_DYNAMIC+0x268>
  182964:	48 85 c0             	test   %rax,%rax
  182967:	0f 84 41 0b 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  18296d:	49 89 c5             	mov    %rax,%r13
  182970:	48 b8 64 69 61 67 6e 	movabs $0x74736f6e67616964,%rax
  182977:	6f 73 74 
  18297a:	49 89 45 00          	mov    %rax,0x0(%r13)
  18297e:	41 c7 45 07 74 69 63 	movl   $0x73636974,0x7(%r13)
  182985:	73 
  182986:	48 c7 44 24 08 0b 00 	movq   $0xb,0x8(%rsp)
  18298d:	00 00 
  18298f:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  182994:	48 c7 44 24 18 0b 00 	movq   $0xb,0x18(%rsp)
  18299b:	00 00 
  18299d:	ff 15 d5 1d 4c 00    	call   *0x4c1dd5(%rip)        # 644778 <_DYNAMIC+0x260>
  1829a3:	bf 0e 00 00 00       	mov    $0xe,%edi
  1829a8:	be 01 00 00 00       	mov    $0x1,%esi
  1829ad:	ff 15 cd 1d 4c 00    	call   *0x4c1dcd(%rip)        # 644780 <_DYNAMIC+0x268>
  1829b3:	48 85 c0             	test   %rax,%rax
  1829b6:	0f 84 63 0b 00 00    	je     18351f <allocation_pmu_probe::main+0x1c7f>
  1829bc:	48 b9 74 69 6f 6e 2d 	movabs $0x756d702d6e6f6974,%rcx
  1829c3:	70 6d 75 
  1829c6:	48 89 48 06          	mov    %rcx,0x6(%rax)
  1829ca:	48 b9 61 6c 6c 6f 63 	movabs $0x697461636f6c6c61,%rcx
  1829d1:	61 74 69 
  1829d4:	48 89 08             	mov    %rcx,(%rax)
  1829d7:	c6 44 24 68 03       	movb   $0x3,0x68(%rsp)
  1829dc:	48 c7 44 24 70 0e 00 	movq   $0xe,0x70(%rsp)
  1829e3:	00 00 
  1829e5:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  1829ea:	48 c7 84 24 80 00 00 	movq   $0xe,0x80(%rsp)
  1829f1:	00 0e 00 00 00 
  1829f6:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1829fb:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182a02:	00 
  182a03:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182a08:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182a0d:	e8 7e a6 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182a12:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182a17:	74 0a                	je     182a23 <allocation_pmu_probe::main+0x1183>
  182a19:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182a1e:	e8 4d e4 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182a23:	ff 15 4f 1d 4c 00    	call   *0x4c1d4f(%rip)        # 644778 <_DYNAMIC+0x260>
  182a29:	41 bf 09 00 00 00    	mov    $0x9,%r15d
  182a2f:	bf 09 00 00 00       	mov    $0x9,%edi
  182a34:	be 01 00 00 00       	mov    $0x1,%esi
  182a39:	ff 15 41 1d 4c 00    	call   *0x4c1d41(%rip)        # 644780 <_DYNAMIC+0x268>
  182a3f:	48 85 c0             	test   %rax,%rax
  182a42:	0f 84 66 0a 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182a48:	49 89 c5             	mov    %rax,%r13
  182a4b:	48 b8 77 69 6e 64 6f 	movabs $0x6e5f776f646e6977,%rax
  182a52:	77 5f 6e 
  182a55:	49 89 45 00          	mov    %rax,0x0(%r13)
  182a59:	41 c6 45 08 73       	movb   $0x73,0x8(%r13)
  182a5e:	48 c7 44 24 08 09 00 	movq   $0x9,0x8(%rsp)
  182a65:	00 00 
  182a67:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  182a6c:	48 c7 44 24 18 09 00 	movq   $0x9,0x18(%rsp)
  182a73:	00 00 
  182a75:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182a7a:	48 8b b4 24 a0 01 00 	mov    0x1a0(%rsp),%rsi
  182a81:	00 
  182a82:	48 8b 94 24 a8 01 00 	mov    0x1a8(%rsp),%rdx
  182a89:	00 
  182a8a:	ff 15 78 21 4c 00    	call   *0x4c2178(%rip)        # 644c08 <_DYNAMIC+0x6f0>
  182a90:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  182a95:	0f 84 fd 08 00 00    	je     183398 <allocation_pmu_probe::main+0x1af8>
  182a9b:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  182aa0:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  182aa5:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  182aaa:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  182aaf:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182ab4:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182abb:	00 
  182abc:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182ac1:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  182ac6:	e8 c5 a5 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182acb:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  182ad0:	74 0a                	je     182adc <allocation_pmu_probe::main+0x123c>
  182ad2:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182ad7:	e8 94 e3 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182adc:	ff 15 96 1c 4c 00    	call   *0x4c1c96(%rip)        # 644778 <_DYNAMIC+0x260>
  182ae2:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  182ae8:	bf 08 00 00 00       	mov    $0x8,%edi
  182aed:	be 01 00 00 00       	mov    $0x1,%esi
  182af2:	ff 15 88 1c 4c 00    	call   *0x4c1c88(%rip)        # 644780 <_DYNAMIC+0x268>
  182af8:	48 85 c0             	test   %rax,%rax
  182afb:	0f 84 ad 09 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182b01:	49 89 c5             	mov    %rax,%r13
  182b04:	48 b8 77 72 69 74 65 	movabs $0x736e5f6574697277,%rax
  182b0b:	5f 6e 73 
  182b0e:	49 89 45 00          	mov    %rax,0x0(%r13)
  182b12:	48 c7 44 24 08 08 00 	movq   $0x8,0x8(%rsp)
  182b19:	00 00 
  182b1b:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  182b20:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  182b27:	00 00 
  182b29:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182b2e:	48 89 de             	mov    %rbx,%rsi
  182b31:	4c 89 e2             	mov    %r12,%rdx
  182b34:	ff 15 ce 20 4c 00    	call   *0x4c20ce(%rip)        # 644c08 <_DYNAMIC+0x6f0>
  182b3a:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  182b3f:	0f 84 87 08 00 00    	je     1833cc <allocation_pmu_probe::main+0x1b2c>
  182b45:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  182b4a:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  182b4f:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  182b54:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  182b59:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182b5e:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182b65:	00 
  182b66:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182b6b:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  182b70:	e8 1b a5 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182b75:	80 7c 24 68 ff       	cmpb   $0xff,0x68(%rsp)
  182b7a:	74 0a                	je     182b86 <allocation_pmu_probe::main+0x12e6>
  182b7c:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182b81:	e8 ea e2 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182b86:	ff 15 ec 1b 4c 00    	call   *0x4c1bec(%rip)        # 644778 <_DYNAMIC+0x260>
  182b8c:	41 bf 0c 00 00 00    	mov    $0xc,%r15d
  182b92:	bf 0c 00 00 00       	mov    $0xc,%edi
  182b97:	be 01 00 00 00       	mov    $0x1,%esi
  182b9c:	ff 15 de 1b 4c 00    	call   *0x4c1bde(%rip)        # 644780 <_DYNAMIC+0x268>
  182ba2:	48 85 c0             	test   %rax,%rax
  182ba5:	0f 84 03 09 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182bab:	48 b9 72 65 63 6f 72 	movabs $0x625f64726f636572,%rcx
  182bb2:	64 5f 62 
  182bb5:	48 89 08             	mov    %rcx,(%rax)
  182bb8:	c7 40 08 79 74 65 73 	movl   $0x73657479,0x8(%rax)
  182bbf:	48 c7 44 24 08 0c 00 	movq   $0xc,0x8(%rsp)
  182bc6:	00 00 
  182bc8:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182bcd:	48 c7 44 24 18 0c 00 	movq   $0xc,0x18(%rsp)
  182bd4:	00 00 
  182bd6:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  182bdb:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182be0:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182be7:	00 00 
  182be9:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  182bee:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182bf3:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182bfa:	00 
  182bfb:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182c00:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182c05:	e8 86 a4 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182c0a:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182c0f:	74 0a                	je     182c1b <allocation_pmu_probe::main+0x137b>
  182c11:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182c16:	e8 55 e2 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182c1b:	ff 15 57 1b 4c 00    	call   *0x4c1b57(%rip)        # 644778 <_DYNAMIC+0x260>
  182c21:	41 bf 0f 00 00 00    	mov    $0xf,%r15d
  182c27:	bf 0f 00 00 00       	mov    $0xf,%edi
  182c2c:	be 01 00 00 00       	mov    $0x1,%esi
  182c31:	ff 15 49 1b 4c 00    	call   *0x4c1b49(%rip)        # 644780 <_DYNAMIC+0x268>
  182c37:	48 85 c0             	test   %rax,%rax
  182c3a:	0f 84 6e 08 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182c40:	48 b9 79 5f 62 65 66 	movabs $0x65726f6665625f79,%rcx
  182c47:	6f 72 65 
  182c4a:	48 89 48 07          	mov    %rcx,0x7(%rax)
  182c4e:	48 bb 63 61 70 61 63 	movabs $0x7974696361706163,%rbx
  182c55:	69 74 79 
  182c58:	48 89 18             	mov    %rbx,(%rax)
  182c5b:	48 c7 44 24 08 0f 00 	movq   $0xf,0x8(%rsp)
  182c62:	00 00 
  182c64:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182c69:	48 c7 44 24 18 0f 00 	movq   $0xf,0x18(%rsp)
  182c70:	00 00 
  182c72:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182c77:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182c7e:	00 00 
  182c80:	4c 89 74 24 78       	mov    %r14,0x78(%rsp)
  182c85:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182c8a:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182c91:	00 
  182c92:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182c97:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182c9c:	e8 ef a3 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182ca1:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182ca6:	74 0a                	je     182cb2 <allocation_pmu_probe::main+0x1412>
  182ca8:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182cad:	e8 be e1 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182cb2:	ff 15 c0 1a 4c 00    	call   *0x4c1ac0(%rip)        # 644778 <_DYNAMIC+0x260>
  182cb8:	41 bf 0e 00 00 00    	mov    $0xe,%r15d
  182cbe:	bf 0e 00 00 00       	mov    $0xe,%edi
  182cc3:	be 01 00 00 00       	mov    $0x1,%esi
  182cc8:	ff 15 b2 1a 4c 00    	call   *0x4c1ab2(%rip)        # 644780 <_DYNAMIC+0x268>
  182cce:	48 85 c0             	test   %rax,%rax
  182cd1:	0f 84 d7 07 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182cd7:	48 b9 74 79 5f 61 66 	movabs $0x72657466615f7974,%rcx
  182cde:	74 65 72 
  182ce1:	48 89 48 06          	mov    %rcx,0x6(%rax)
  182ce5:	48 89 18             	mov    %rbx,(%rax)
  182ce8:	48 c7 44 24 08 0e 00 	movq   $0xe,0x8(%rsp)
  182cef:	00 00 
  182cf1:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182cf6:	48 c7 44 24 18 0e 00 	movq   $0xe,0x18(%rsp)
  182cfd:	00 00 
  182cff:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  182d04:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182d09:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182d10:	00 00 
  182d12:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  182d17:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182d1c:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182d23:	00 
  182d24:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182d29:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
  182d2e:	e8 5d a3 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182d33:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182d38:	74 0a                	je     182d44 <allocation_pmu_probe::main+0x14a4>
  182d3a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182d3f:	e8 2c e1 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182d44:	ff 15 2e 1a 4c 00    	call   *0x4c1a2e(%rip)        # 644778 <_DYNAMIC+0x260>
  182d4a:	41 bf 09 00 00 00    	mov    $0x9,%r15d
  182d50:	bf 09 00 00 00       	mov    $0x9,%edi
  182d55:	be 01 00 00 00       	mov    $0x1,%esi
  182d5a:	ff 15 20 1a 4c 00    	call   *0x4c1a20(%rip)        # 644780 <_DYNAMIC+0x268>
  182d60:	48 85 c0             	test   %rax,%rax
  182d63:	0f 84 45 07 00 00    	je     1834ae <allocation_pmu_probe::main+0x1c0e>
  182d69:	48 b9 61 63 6b 5f 62 	movabs $0x657479625f6b6361,%rcx
  182d70:	79 74 65 
  182d73:	48 89 08             	mov    %rcx,(%rax)
  182d76:	c6 40 08 73          	movb   $0x73,0x8(%rax)
  182d7a:	48 c7 44 24 08 09 00 	movq   $0x9,0x8(%rsp)
  182d81:	00 00 
  182d83:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  182d88:	48 c7 44 24 18 09 00 	movq   $0x9,0x18(%rsp)
  182d8f:	00 00 
  182d91:	c6 44 24 68 02       	movb   $0x2,0x68(%rsp)
  182d96:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  182d9d:	00 00 
  182d9f:	48 c7 44 24 78 05 00 	movq   $0x5,0x78(%rsp)
  182da6:	00 00 
  182da8:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182dad:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
  182db4:	00 
  182db5:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  182dba:	48 8d 5c 24 68       	lea    0x68(%rsp),%rbx
  182dbf:	48 89 d9             	mov    %rbx,%rcx
  182dc2:	e8 c9 a2 fc ff       	call   14d090 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value>>::insert>
  182dc7:	80 7c 24 20 ff       	cmpb   $0xff,0x20(%rsp)
  182dcc:	74 0a                	je     182dd8 <allocation_pmu_probe::main+0x1538>
  182dce:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  182dd3:	e8 98 e0 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182dd8:	0f 10 84 24 c8 00 00 	movups 0xc8(%rsp),%xmm0
  182ddf:	00 
  182de0:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  182de5:	48 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%rax
  182dec:	00 
  182ded:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  182df4:	00 
  182df5:	c6 44 24 68 05       	movb   $0x5,0x68(%rsp)
  182dfa:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  182dff:	48 8b 05 62 1a 4c 00 	mov    0x4c1a62(%rip),%rax        # 644868 <_DYNAMIC+0x350>
  182e06:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  182e0b:	48 8d 3d bc 88 ee ff 	lea    -0x117744(%rip),%rdi        # 6b6ce <anon.e8c9979099957ea97e14e3734d806e91.11.llvm.12140543486298777174+0xf3>
  182e12:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  182e17:	ff 15 33 1f 4c 00    	call   *0x4c1f33(%rip)        # 644d50 <_DYNAMIC+0x838>
  182e1d:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  182e22:	e8 49 e0 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182e27:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  182e2c:	48 85 f6             	test   %rsi,%rsi
  182e2f:	74 10                	je     182e41 <allocation_pmu_probe::main+0x15a1>
  182e31:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  182e36:	ba 01 00 00 00       	mov    $0x1,%edx
  182e3b:	ff 15 47 19 4c 00    	call   *0x4c1947(%rip)        # 644788 <_DYNAMIC+0x270>
  182e41:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  182e48:	00 
  182e49:	48 85 f6             	test   %rsi,%rsi
  182e4c:	74 13                	je     182e61 <allocation_pmu_probe::main+0x15c1>
  182e4e:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  182e55:	00 
  182e56:	ba 01 00 00 00       	mov    $0x1,%edx
  182e5b:	ff 15 27 19 4c 00    	call   *0x4c1927(%rip)        # 644788 <_DYNAMIC+0x270>
  182e61:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  182e68:	00 
  182e69:	48 85 f6             	test   %rsi,%rsi
  182e6c:	74 13                	je     182e81 <allocation_pmu_probe::main+0x15e1>
  182e6e:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  182e75:	00 
  182e76:	ba 01 00 00 00       	mov    $0x1,%edx
  182e7b:	ff 15 07 19 4c 00    	call   *0x4c1907(%rip)        # 644788 <_DYNAMIC+0x270>
  182e81:	41 b6 01             	mov    $0x1,%r14b
  182e84:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  182e8b:	00 
  182e8c:	e8 5f da ff ff       	call   1808f0 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  182e91:	48 8d bc 24 78 08 00 	lea    0x878(%rsp),%rdi
  182e98:	00 
  182e99:	e8 d2 df ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  182e9e:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  182ea5:	00 
  182ea6:	e8 25 cf ff ff       	call   17fdd0 <core::ptr::drop_glue::<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>>
  182eab:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  182eb2:	00 
  182eb3:	e8 f8 e0 ff ff       	call   180fb0 <core::ptr::drop_glue::<behavior_core::semantic::module::Module>>
  182eb8:	48 8b b4 24 b0 01 00 	mov    0x1b0(%rsp),%rsi
  182ebf:	00 
  182ec0:	48 85 f6             	test   %rsi,%rsi
  182ec3:	74 13                	je     182ed8 <allocation_pmu_probe::main+0x1638>
  182ec5:	ba 01 00 00 00       	mov    $0x1,%edx
  182eca:	48 8b bc 24 98 01 00 	mov    0x198(%rsp),%rdi
  182ed1:	00 
  182ed2:	ff 15 b0 18 4c 00    	call   *0x4c18b0(%rip)        # 644788 <_DYNAMIC+0x270>
  182ed8:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  182edf:	00 
  182ee0:	48 85 f6             	test   %rsi,%rsi
  182ee3:	74 13                	je     182ef8 <allocation_pmu_probe::main+0x1658>
  182ee5:	48 8b bc 24 08 02 00 	mov    0x208(%rsp),%rdi
  182eec:	00 
  182eed:	ba 01 00 00 00       	mov    $0x1,%edx
  182ef2:	ff 15 90 18 4c 00    	call   *0x4c1890(%rip)        # 644788 <_DYNAMIC+0x270>
  182ef8:	48 8b b4 24 18 02 00 	mov    0x218(%rsp),%rsi
  182eff:	00 
  182f00:	48 85 f6             	test   %rsi,%rsi
  182f03:	74 13                	je     182f18 <allocation_pmu_probe::main+0x1678>
  182f05:	48 8b bc 24 20 02 00 	mov    0x220(%rsp),%rdi
  182f0c:	00 
  182f0d:	ba 01 00 00 00       	mov    $0x1,%edx
  182f12:	ff 15 70 18 4c 00    	call   *0x4c1870(%rip)        # 644788 <_DYNAMIC+0x270>
  182f18:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
  182f1f:	00 
  182f20:	48 85 f6             	test   %rsi,%rsi
  182f23:	74 13                	je     182f38 <allocation_pmu_probe::main+0x1698>
  182f25:	ba 01 00 00 00       	mov    $0x1,%edx
  182f2a:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  182f31:	00 
  182f32:	ff 15 50 18 4c 00    	call   *0x4c1850(%rip)        # 644788 <_DYNAMIC+0x270>
  182f38:	8b 7c 24 64          	mov    0x64(%rsp),%edi
  182f3c:	48 8b 1d 15 1e 4c 00 	mov    0x4c1e15(%rip),%rbx        # 644d58 <close@GLIBC_2.2.5>
  182f43:	ff d3                	call   *%rbx
  182f45:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  182f49:	ff d3                	call   *%rbx
  182f4b:	48 8b 9c 24 00 01 00 	mov    0x100(%rsp),%rbx
  182f52:	00 
  182f53:	4c 8b b4 24 08 01 00 	mov    0x108(%rsp),%r14
  182f5a:	00 
  182f5b:	4d 85 f6             	test   %r14,%r14
  182f5e:	74 2f                	je     182f8f <allocation_pmu_probe::main+0x16ef>
  182f60:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  182f64:	4c 8b 25 1d 18 4c 00 	mov    0x4c181d(%rip),%r12        # 644788 <_DYNAMIC+0x270>
  182f6b:	eb 0c                	jmp    182f79 <allocation_pmu_probe::main+0x16d9>
  182f6d:	0f 1f 00             	nopl   (%rax)
  182f70:	49 83 c7 18          	add    $0x18,%r15
  182f74:	49 ff ce             	dec    %r14
  182f77:	74 16                	je     182f8f <allocation_pmu_probe::main+0x16ef>
  182f79:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  182f7d:	48 85 f6             	test   %rsi,%rsi
  182f80:	74 ee                	je     182f70 <allocation_pmu_probe::main+0x16d0>
  182f82:	49 8b 3f             	mov    (%r15),%rdi
  182f85:	ba 01 00 00 00       	mov    $0x1,%edx
  182f8a:	41 ff d4             	call   *%r12
  182f8d:	eb e1                	jmp    182f70 <allocation_pmu_probe::main+0x16d0>
  182f8f:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  182f96:	00 
  182f97:	48 85 c0             	test   %rax,%rax
  182f9a:	74 16                	je     182fb2 <allocation_pmu_probe::main+0x1712>
  182f9c:	48 c1 e0 03          	shl    $0x3,%rax
  182fa0:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  182fa4:	ba 08 00 00 00       	mov    $0x8,%edx
  182fa9:	48 89 df             	mov    %rbx,%rdi
  182fac:	ff 15 d6 17 4c 00    	call   *0x4c17d6(%rip)        # 644788 <_DYNAMIC+0x270>
  182fb2:	48 81 c4 18 0e 00 00 	add    $0xe18,%rsp
  182fb9:	5b                   	pop    %rbx
  182fba:	41 5c                	pop    %r12
  182fbc:	41 5d                	pop    %r13
  182fbe:	41 5e                	pop    %r14
  182fc0:	41 5f                	pop    %r15
  182fc2:	5d                   	pop    %rbp
  182fc3:	c3                   	ret
  182fc4:	80 c2 d0             	add    $0xd0,%dl
  182fc7:	31 c0                	xor    %eax,%eax
  182fc9:	80 fa 0a             	cmp    $0xa,%dl
  182fcc:	14 01                	adc    $0x1,%al
  182fce:	88 84 24 78 02 00 00 	mov    %al,0x278(%rsp)
  182fd5:	4c 8d 05 ac 7c 4b 00 	lea    0x4b7cac(%rip),%r8        # 63ac88 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x18>
  182fdc:	eb 18                	jmp    182ff6 <allocation_pmu_probe::main+0x1756>
  182fde:	80 c2 d0             	add    $0xd0,%dl
  182fe1:	31 c0                	xor    %eax,%eax
  182fe3:	80 fa 0a             	cmp    $0xa,%dl
  182fe6:	14 01                	adc    $0x1,%al
  182fe8:	88 84 24 78 02 00 00 	mov    %al,0x278(%rsp)
  182fef:	4c 8d 05 aa 7c 4b 00 	lea    0x4b7caa(%rip),%r8        # 63aca0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x30>
  182ff6:	48 8d 3d 9c 21 ef ff 	lea    -0x10de64(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  182ffd:	48 8d 0d 0c 7f 4b 00 	lea    0x4b7f0c(%rip),%rcx        # 63af10 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x2a0>
  183004:	be 2b 00 00 00       	mov    $0x2b,%esi
  183009:	48 89 da             	mov    %rbx,%rdx
  18300c:	ff 15 66 18 4c 00    	call   *0x4c1866(%rip)        # 644878 <_DYNAMIC+0x360>
  183012:	e9 36 05 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183017:	45 31 f6             	xor    %r14d,%r14d
  18301a:	48 8d 15 27 7d 4b 00 	lea    0x4b7d27(%rip),%rdx        # 63ad48 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xd8>
  183021:	4c 8d 0d 08 7e 4b 00 	lea    0x4b7e08(%rip),%r9        # 63ae30 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1c0>
  183028:	31 ff                	xor    %edi,%edi
  18302a:	48 89 c6             	mov    %rax,%rsi
  18302d:	31 c9                	xor    %ecx,%ecx
  18302f:	e8 16 0f 00 00       	call   183f4a <core::panicking::assert_failed::<serde_json::value::Value, &str>>
  183034:	e9 14 05 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183039:	48 8d 0d da 20 ef ff 	lea    -0x10df26(%rip),%rcx        # 7511a <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x111>
  183040:	4c 8d 0d 89 7d 4b 00 	lea    0x4b7d89(%rip),%r9        # 63add0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x160>
  183047:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
  18304c:	48 8d 94 24 10 01 00 	lea    0x110(%rsp),%rdx
  183053:	00 
  183054:	41 b8 45 00 00 00    	mov    $0x45,%r8d
  18305a:	31 ff                	xor    %edi,%edi
  18305c:	e8 b6 0e 00 00       	call   183f17 <core::panicking::assert_failed::<alloc::vec::Vec<u8>, alloc::vec::Vec<u8>>>
  183061:	e9 e7 04 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183066:	48 8d 15 43 18 ef ff 	lea    -0x10e7bd(%rip),%rdx        # 748b0 <anon.f0ce8b4fff13ea61fcd41c9a7fbb4fc9.42.llvm.102737351613787692+0x10>
  18306d:	48 8d 0d ec 20 ef ff 	lea    -0x10df14(%rip),%rcx        # 75160 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x157>
  183074:	4c 8d 0d cd 7d 4b 00 	lea    0x4b7dcd(%rip),%r9        # 63ae48 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1d8>
  18307b:	48 8d b4 24 78 02 00 	lea    0x278(%rsp),%rsi
  183082:	00 
  183083:	41 b8 65 00 00 00    	mov    $0x65,%r8d
  183089:	31 ff                	xor    %edi,%edi
  18308b:	ff 15 cf 1c 4c 00    	call   *0x4c1ccf(%rip)        # 644d60 <_DYNAMIC+0x848>
  183091:	e9 b7 04 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183096:	48 8b 84 24 a8 08 00 	mov    0x8a8(%rsp),%rax
  18309d:	00 
  18309e:	48 89 84 24 40 06 00 	mov    %rax,0x640(%rsp)
  1830a5:	00 
  1830a6:	48 8d 3d ec 20 ef ff 	lea    -0x10df14(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1830ad:	48 8d 0d fc 7d 4b 00 	lea    0x4b7dfc(%rip),%rcx        # 63aeb0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  1830b4:	4c 8d 05 15 7c 4b 00 	lea    0x4b7c15(%rip),%r8        # 63acd0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x60>
  1830bb:	48 8d 94 24 40 06 00 	lea    0x640(%rsp),%rdx
  1830c2:	00 
  1830c3:	be 2b 00 00 00       	mov    $0x2b,%esi
  1830c8:	ff 15 aa 17 4c 00    	call   *0x4c17aa(%rip)        # 644878 <_DYNAMIC+0x360>
  1830ce:	e9 7a 04 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1830d3:	48 8b 84 24 a8 08 00 	mov    0x8a8(%rsp),%rax
  1830da:	00 
  1830db:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  1830e2:	00 
  1830e3:	48 8d 3d af 20 ef ff 	lea    -0x10df51(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1830ea:	48 8d 0d bf 7d 4b 00 	lea    0x4b7dbf(%rip),%rcx        # 63aeb0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  1830f1:	4c 8d 05 f0 7b 4b 00 	lea    0x4b7bf0(%rip),%r8        # 63ace8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x78>
  1830f8:	48 8d 94 24 78 02 00 	lea    0x278(%rsp),%rdx
  1830ff:	00 
  183100:	be 2b 00 00 00       	mov    $0x2b,%esi
  183105:	ff 15 6d 17 4c 00    	call   *0x4c176d(%rip)        # 644878 <_DYNAMIC+0x360>
  18310b:	e9 3d 04 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183110:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
  183117:	00 
  183118:	48 89 84 24 a0 08 00 	mov    %rax,0x8a0(%rsp)
  18311f:	00 
  183120:	48 8d 3d 72 20 ef ff 	lea    -0x10df8e(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  183127:	48 8d 0d 82 7d 4b 00 	lea    0x4b7d82(%rip),%rcx        # 63aeb0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  18312e:	4c 8d 05 cb 7b 4b 00 	lea    0x4b7bcb(%rip),%r8        # 63ad00 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x90>
  183135:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  18313c:	00 
  18313d:	be 2b 00 00 00       	mov    $0x2b,%esi
  183142:	ff 15 30 17 4c 00    	call   *0x4c1730(%rip)        # 644878 <_DYNAMIC+0x360>
  183148:	e9 00 04 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  18314d:	0f 10 84 24 d0 02 00 	movups 0x2d0(%rsp),%xmm0
  183154:	00 
  183155:	0f 29 84 24 f0 08 00 	movaps %xmm0,0x8f0(%rsp)
  18315c:	00 
  18315d:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  183164:	00 
  183165:	0f 29 84 24 e0 08 00 	movaps %xmm0,0x8e0(%rsp)
  18316c:	00 
  18316d:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  183174:	00 
  183175:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  18317c:	00 
  18317d:	0f 10 94 24 a0 02 00 	movups 0x2a0(%rsp),%xmm2
  183184:	00 
  183185:	0f 10 9c 24 b0 02 00 	movups 0x2b0(%rsp),%xmm3
  18318c:	00 
  18318d:	0f 29 9c 24 d0 08 00 	movaps %xmm3,0x8d0(%rsp)
  183194:	00 
  183195:	0f 29 94 24 c0 08 00 	movaps %xmm2,0x8c0(%rsp)
  18319c:	00 
  18319d:	0f 29 8c 24 b0 08 00 	movaps %xmm1,0x8b0(%rsp)
  1831a4:	00 
  1831a5:	0f 29 84 24 a0 08 00 	movaps %xmm0,0x8a0(%rsp)
  1831ac:	00 
  1831ad:	48 8d 3d e5 1f ef ff 	lea    -0x10e01b(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1831b4:	48 8d 0d 15 7d 4b 00 	lea    0x4b7d15(%rip),%rcx        # 63aed0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  1831bb:	4c 8d 05 56 7b 4b 00 	lea    0x4b7b56(%rip),%r8        # 63ad18 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xa8>
  1831c2:	48 8d 94 24 a0 08 00 	lea    0x8a0(%rsp),%rdx
  1831c9:	00 
  1831ca:	be 2b 00 00 00       	mov    $0x2b,%esi
  1831cf:	ff 15 a3 16 4c 00    	call   *0x4c16a3(%rip)        # 644878 <_DYNAMIC+0x360>
  1831d5:	e9 73 03 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1831da:	0f 10 84 24 d0 02 00 	movups 0x2d0(%rsp),%xmm0
  1831e1:	00 
  1831e2:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  1831e9:	00 
  1831ea:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  1831f1:	00 
  1831f2:	0f 29 84 24 80 06 00 	movaps %xmm0,0x680(%rsp)
  1831f9:	00 
  1831fa:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  183201:	00 
  183202:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  183209:	00 
  18320a:	0f 10 94 24 a0 02 00 	movups 0x2a0(%rsp),%xmm2
  183211:	00 
  183212:	0f 10 9c 24 b0 02 00 	movups 0x2b0(%rsp),%xmm3
  183219:	00 
  18321a:	0f 29 9c 24 70 06 00 	movaps %xmm3,0x670(%rsp)
  183221:	00 
  183222:	0f 29 94 24 60 06 00 	movaps %xmm2,0x660(%rsp)
  183229:	00 
  18322a:	0f 29 8c 24 50 06 00 	movaps %xmm1,0x650(%rsp)
  183231:	00 
  183232:	0f 29 84 24 40 06 00 	movaps %xmm0,0x640(%rsp)
  183239:	00 
  18323a:	48 8d 3d 58 1f ef ff 	lea    -0x10e0a8(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  183241:	48 8d 0d 88 7c 4b 00 	lea    0x4b7c88(%rip),%rcx        # 63aed0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  183248:	4c 8d 05 e1 7a 4b 00 	lea    0x4b7ae1(%rip),%r8        # 63ad30 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xc0>
  18324f:	48 8d 94 24 40 06 00 	lea    0x640(%rsp),%rdx
  183256:	00 
  183257:	be 2b 00 00 00       	mov    $0x2b,%esi
  18325c:	ff 15 16 16 4c 00    	call   *0x4c1616(%rip)        # 644878 <_DYNAMIC+0x360>
  183262:	e9 e6 02 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183267:	41 b6 01             	mov    $0x1,%r14b
  18326a:	48 8d 3d e7 7a 4b 00 	lea    0x4b7ae7(%rip),%rdi        # 63ad58 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0xe8>
  183271:	ff 15 39 15 4c 00    	call   *0x4c1539(%rip)        # 6447b0 <_DYNAMIC+0x298>
  183277:	e9 d1 02 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  18327c:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  183283:	00 
  183284:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  18328b:	00 
  18328c:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  183293:	00 
  183294:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  18329b:	00 
  18329c:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  1832a1:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
  1832a6:	0f 10 94 24 88 00 00 	movups 0x88(%rsp),%xmm2
  1832ad:	00 
  1832ae:	0f 10 9c 24 98 00 00 	movups 0x98(%rsp),%xmm3
  1832b5:	00 
  1832b6:	0f 29 9c 24 60 01 00 	movaps %xmm3,0x160(%rsp)
  1832bd:	00 
  1832be:	0f 29 94 24 50 01 00 	movaps %xmm2,0x150(%rsp)
  1832c5:	00 
  1832c6:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
  1832cd:	00 
  1832ce:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  1832d5:	00 
  1832d6:	48 8d 3d bc 1e ef ff 	lea    -0x10e144(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1832dd:	48 8d 0d ec 7b 4b 00 	lea    0x4b7bec(%rip),%rcx        # 63aed0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x260>
  1832e4:	4c 8d 05 85 7a 4b 00 	lea    0x4b7a85(%rip),%r8        # 63ad70 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x100>
  1832eb:	48 8d 94 24 30 01 00 	lea    0x130(%rsp),%rdx
  1832f2:	00 
  1832f3:	be 2b 00 00 00       	mov    $0x2b,%esi
  1832f8:	ff 15 7a 15 4c 00    	call   *0x4c157a(%rip)        # 644878 <_DYNAMIC+0x360>
  1832fe:	e9 4a 02 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183303:	48 8d 3d 32 1e ef ff 	lea    -0x10e1ce(%rip),%rdi        # 7513c <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x133>
  18330a:	48 8d 15 07 7b 4b 00 	lea    0x4b7b07(%rip),%rdx        # 63ae18 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x1a8>
  183311:	be 24 00 00 00       	mov    $0x24,%esi
  183316:	ff 15 8c 14 4c 00    	call   *0x4c148c(%rip)        # 6447a8 <_DYNAMIC+0x290>
  18331c:	e9 2c 02 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183321:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
  183328:	00 
  183329:	48 8d 15 a8 14 ef ff 	lea    -0x10eb58(%rip),%rdx        # 747d8 <anon.09fc6582434f2c178fb0b95537f8989c.218.llvm.3090248892101229199+0x8>
  183330:	4c 8d 0d c9 7a 4b 00 	lea    0x4b7ac9(%rip),%r9        # 63ae00 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x190>
  183337:	31 ff                	xor    %edi,%edi
  183339:	31 c9                	xor    %ecx,%ecx
  18333b:	ff 15 27 1a 4c 00    	call   *0x4c1a27(%rip)        # 644d68 <_DYNAMIC+0x850>
  183341:	e9 07 02 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183346:	4c 8d 0d 53 7a 4b 00 	lea    0x4b7a53(%rip),%r9        # 63ada0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x130>
  18334d:	48 8d b4 24 c0 01 00 	lea    0x1c0(%rsp),%rsi
  183354:	00 
  183355:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  18335a:	31 ff                	xor    %edi,%edi
  18335c:	31 c9                	xor    %ecx,%ecx
  18335e:	ff 15 fc 19 4c 00    	call   *0x4c19fc(%rip)        # 644d60 <_DYNAMIC+0x848>
  183364:	e9 e4 01 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183369:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  18336e:	48 8d 3d 24 1e ef ff 	lea    -0x10e1dc(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  183375:	48 8d 0d 34 7b 4b 00 	lea    0x4b7b34(%rip),%rcx        # 63aeb0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x240>
  18337c:	4c 8d 05 35 7a 4b 00 	lea    0x4b7a35(%rip),%r8        # 63adb8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x148>
  183383:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  183388:	be 2b 00 00 00       	mov    $0x2b,%esi
  18338d:	ff 15 e5 14 4c 00    	call   *0x4c14e5(%rip)        # 644878 <_DYNAMIC+0x360>
  183393:	e9 b5 01 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183398:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  18339d:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  1833a2:	48 8d 3d f0 1d ef ff 	lea    -0x10e210(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1833a9:	48 8d 0d 40 7b 4b 00 	lea    0x4b7b40(%rip),%rcx        # 63aef0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  1833b0:	4c 8d 05 31 7a 4b 00 	lea    0x4b7a31(%rip),%r8        # 63ade8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x178>
  1833b7:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  1833bc:	be 2b 00 00 00       	mov    $0x2b,%esi
  1833c1:	ff 15 b1 14 4c 00    	call   *0x4c14b1(%rip)        # 644878 <_DYNAMIC+0x360>
  1833c7:	e9 81 01 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1833cc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  1833d1:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  1833d6:	48 8d 3d bc 1d ef ff 	lea    -0x10e244(%rip),%rdi        # 75199 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0x190>
  1833dd:	48 8d 0d 0c 7b 4b 00 	lea    0x4b7b0c(%rip),%rcx        # 63aef0 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x280>
  1833e4:	4c 8d 05 fd 79 4b 00 	lea    0x4b79fd(%rip),%r8        # 63ade8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x178>
  1833eb:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  1833f0:	be 2b 00 00 00       	mov    $0x2b,%esi
  1833f5:	ff 15 7d 14 4c 00    	call   *0x4c147d(%rip)        # 644878 <_DYNAMIC+0x360>
  1833fb:	e9 4d 01 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183400:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  183405:	b9 01 00 00 00       	mov    $0x1,%ecx
  18340a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  183410:	48 89 ee             	mov    %rbp,%rsi
  183413:	48 89 da             	mov    %rbx,%rdx
  183416:	e8 c5 3b 00 00       	call   186fe0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  18341b:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  183420:	e9 bb ef ff ff       	jmp    1823e0 <allocation_pmu_probe::main+0xb40>
  183425:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  18342a:	ba 01 00 00 00       	mov    $0x1,%edx
  18342f:	b9 01 00 00 00       	mov    $0x1,%ecx
  183434:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  18343a:	e8 a1 3b 00 00       	call   186fe0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  18343f:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  183444:	e9 d0 ef ff ff       	jmp    182419 <allocation_pmu_probe::main+0xb79>
  183449:	48 8d 3d 80 6d 4b 00 	lea    0x4b6d80(%rip),%rdi        # 63a1d0 <anon.a0b181daf0748f92ee2071baa91061bb.7.llvm.16326187416535719487>
  183450:	ff 15 5a 13 4c 00    	call   *0x4c135a(%rip)        # 6447b0 <_DYNAMIC+0x298>
  183456:	e9 f2 00 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  18345b:	ba 01 00 00 00       	mov    $0x1,%edx
  183460:	b9 01 00 00 00       	mov    $0x1,%ecx
  183465:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  18346b:	48 89 df             	mov    %rbx,%rdi
  18346e:	e8 6d 3b 00 00       	call   186fe0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  183473:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  183477:	e9 36 f2 ff ff       	jmp    1826b2 <allocation_pmu_probe::main+0xe12>
  18347c:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  183481:	ba 01 00 00 00       	mov    $0x1,%edx
  183486:	b9 01 00 00 00       	mov    $0x1,%ecx
  18348b:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  183491:	e8 4a 3b 00 00       	call   186fe0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  183496:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  18349b:	e9 9c ef ff ff       	jmp    18243c <allocation_pmu_probe::main+0xb9c>
  1834a0:	b0 01                	mov    $0x1,%al
  1834a2:	e9 27 fb ff ff       	jmp    182fce <allocation_pmu_probe::main+0x172e>
  1834a7:	b0 01                	mov    $0x1,%al
  1834a9:	e9 3a fb ff ff       	jmp    182fe8 <allocation_pmu_probe::main+0x1748>
  1834ae:	bf 01 00 00 00       	mov    $0x1,%edi
  1834b3:	4c 89 fe             	mov    %r15,%rsi
  1834b6:	ff 15 44 13 4c 00    	call   *0x4c1344(%rip)        # 644800 <_DYNAMIC+0x2e8>
  1834bc:	e9 8c 00 00 00       	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1834c1:	48 8d 3d 38 6d 4b 00 	lea    0x4b6d38(%rip),%rdi        # 63a200 <anon.a0b181daf0748f92ee2071baa91061bb.9.llvm.16326187416535719487>
  1834c8:	ff 15 e2 12 4c 00    	call   *0x4c12e2(%rip)        # 6447b0 <_DYNAMIC+0x298>
  1834ce:	eb 7d                	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1834d0:	48 8d 3d ea 1b ef ff 	lea    -0x10e416(%rip),%rdi        # 750c1 <anon.985e6a51b797a53bd4cc575640d67e9a.55.llvm.13311365482524361019+0xb8>
  1834d7:	48 8d 15 da 77 4b 00 	lea    0x4b77da(%rip),%rdx        # 63acb8 <anon.985e6a51b797a53bd4cc575640d67e9a.57.llvm.13311365482524361019+0x48>
  1834de:	be 34 00 00 00       	mov    $0x34,%esi
  1834e3:	ff 15 bf 12 4c 00    	call   *0x4c12bf(%rip)        # 6447a8 <_DYNAMIC+0x290>
  1834e9:	eb 62                	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1834eb:	bf 01 00 00 00       	mov    $0x1,%edi
  1834f0:	be 03 00 00 00       	mov    $0x3,%esi
  1834f5:	ff 15 05 13 4c 00    	call   *0x4c1305(%rip)        # 644800 <_DYNAMIC+0x2e8>
  1834fb:	eb 50                	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  1834fd:	bf 01 00 00 00       	mov    $0x1,%edi
  183502:	be 06 00 00 00       	mov    $0x6,%esi
  183507:	ff 15 f3 12 4c 00    	call   *0x4c12f3(%rip)        # 644800 <_DYNAMIC+0x2e8>
  18350d:	eb 3e                	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  18350f:	bf 01 00 00 00       	mov    $0x1,%edi
  183514:	4c 89 f6             	mov    %r14,%rsi
  183517:	ff 15 e3 12 4c 00    	call   *0x4c12e3(%rip)        # 644800 <_DYNAMIC+0x2e8>
  18351d:	eb 2e                	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  18351f:	bf 01 00 00 00       	mov    $0x1,%edi
  183524:	be 0e 00 00 00       	mov    $0xe,%esi
  183529:	ff 15 d1 12 4c 00    	call   *0x4c12d1(%rip)        # 644800 <_DYNAMIC+0x2e8>
  18352f:	eb 1c                	jmp    18354d <allocation_pmu_probe::main+0x1cad>
  183531:	31 c0                	xor    %eax,%eax
  183533:	e9 96 fa ff ff       	jmp    182fce <allocation_pmu_probe::main+0x172e>
  183538:	31 c0                	xor    %eax,%eax
  18353a:	e9 a9 fa ff ff       	jmp    182fe8 <allocation_pmu_probe::main+0x1748>
  18353f:	bf 01 00 00 00       	mov    $0x1,%edi
  183544:	4c 89 f6             	mov    %r14,%rsi
  183547:	ff 15 b3 12 4c 00    	call   *0x4c12b3(%rip)        # 644800 <_DYNAMIC+0x2e8>
  18354d:	0f 0b                	ud2
  18354f:	48 89 c3             	mov    %rax,%rbx
  183552:	e9 d5 02 00 00       	jmp    18382c <allocation_pmu_probe::main+0x1f8c>
  183557:	e9 c4 00 00 00       	jmp    183620 <allocation_pmu_probe::main+0x1d80>
  18355c:	48 89 c3             	mov    %rax,%rbx
  18355f:	e9 15 03 00 00       	jmp    183879 <allocation_pmu_probe::main+0x1fd9>
  183564:	48 89 c3             	mov    %rax,%rbx
  183567:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  18356c:	e8 ff d8 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  183571:	e9 9c 02 00 00       	jmp    183812 <allocation_pmu_probe::main+0x1f72>
  183576:	e9 41 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  18357b:	e9 3c 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  183580:	e9 37 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  183585:	e9 32 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  18358a:	e9 2d 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  18358f:	48 89 c3             	mov    %rax,%rbx
  183592:	e9 51 01 00 00       	jmp    1836e8 <allocation_pmu_probe::main+0x1e48>
  183597:	e9 20 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  18359c:	48 89 c3             	mov    %rax,%rbx
  18359f:	e9 5e 01 00 00       	jmp    183702 <allocation_pmu_probe::main+0x1e62>
  1835a4:	e9 13 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  1835a9:	48 89 c3             	mov    %rax,%rbx
  1835ac:	be 0b 00 00 00       	mov    $0xb,%esi
  1835b1:	e9 51 01 00 00       	jmp    183707 <allocation_pmu_probe::main+0x1e67>
  1835b6:	e9 01 01 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  1835bb:	48 89 c3             	mov    %rax,%rbx
  1835be:	be 04 00 00 00       	mov    $0x4,%esi
  1835c3:	e9 3f 01 00 00       	jmp    183707 <allocation_pmu_probe::main+0x1e67>
  1835c8:	e9 ef 00 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  1835cd:	e9 ea 00 00 00       	jmp    1836bc <allocation_pmu_probe::main+0x1e1c>
  1835d2:	48 89 c3             	mov    %rax,%rbx
  1835d5:	e9 5f 02 00 00       	jmp    183839 <allocation_pmu_probe::main+0x1f99>
  1835da:	48 89 c3             	mov    %rax,%rbx
  1835dd:	eb 0d                	jmp    1835ec <allocation_pmu_probe::main+0x1d4c>
  1835df:	48 89 c3             	mov    %rax,%rbx
  1835e2:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1835e7:	e8 84 d8 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  1835ec:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  1835f1:	e8 ea 0b fd ff       	call   1541e0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  1835f6:	45 31 f6             	xor    %r14d,%r14d
  1835f9:	e9 50 02 00 00       	jmp    18384e <allocation_pmu_probe::main+0x1fae>
  1835fe:	48 89 c3             	mov    %rax,%rbx
  183601:	e9 64 01 00 00       	jmp    18376a <allocation_pmu_probe::main+0x1eca>
  183606:	eb 6f                	jmp    183677 <allocation_pmu_probe::main+0x1dd7>
  183608:	48 89 c3             	mov    %rax,%rbx
  18360b:	be 03 00 00 00       	mov    $0x3,%esi
  183610:	ba 01 00 00 00       	mov    $0x1,%edx
  183615:	4c 89 f7             	mov    %r14,%rdi
  183618:	ff 15 6a 11 4c 00    	call   *0x4c116a(%rip)        # 644788 <_DYNAMIC+0x270>
  18361e:	eb 5a                	jmp    18367a <allocation_pmu_probe::main+0x1dda>
  183620:	48 89 c3             	mov    %rax,%rbx
  183623:	e9 5e 02 00 00       	jmp    183886 <allocation_pmu_probe::main+0x1fe6>
  183628:	48 89 c3             	mov    %rax,%rbx
  18362b:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183632:	00 
  183633:	e8 e8 cb ff ff       	call   180220 <core::ptr::drop_glue::<behavior_store::memory::InMemoryBackend>>
  183638:	e9 49 02 00 00       	jmp    183886 <allocation_pmu_probe::main+0x1fe6>
  18363d:	48 89 c3             	mov    %rax,%rbx
  183640:	4d 85 f6             	test   %r14,%r14
  183643:	0f 84 57 02 00 00    	je     1838a0 <allocation_pmu_probe::main+0x2000>
  183649:	4c 89 e7             	mov    %r12,%rdi
  18364c:	4c 89 f6             	mov    %r14,%rsi
  18364f:	ba 01 00 00 00       	mov    $0x1,%edx
  183654:	ff 15 2e 11 4c 00    	call   *0x4c112e(%rip)        # 644788 <_DYNAMIC+0x270>
  18365a:	e9 41 02 00 00       	jmp    1838a0 <allocation_pmu_probe::main+0x2000>
  18365f:	48 89 c3             	mov    %rax,%rbx
  183662:	e9 39 02 00 00       	jmp    1838a0 <allocation_pmu_probe::main+0x2000>
  183667:	48 89 c3             	mov    %rax,%rbx
  18366a:	e9 51 02 00 00       	jmp    1838c0 <allocation_pmu_probe::main+0x2020>
  18366f:	48 89 c3             	mov    %rax,%rbx
  183672:	e9 59 01 00 00       	jmp    1837d0 <allocation_pmu_probe::main+0x1f30>
  183677:	48 89 c3             	mov    %rax,%rbx
  18367a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  18367f:	e8 ec 14 fd ff       	call   154b70 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value> as core::ops::drop::Drop>::drop>
  183684:	e9 f8 00 00 00       	jmp    183781 <allocation_pmu_probe::main+0x1ee1>
  183689:	48 89 c3             	mov    %rax,%rbx
  18368c:	49 8d 46 ff          	lea    -0x1(%r14),%rax
  183690:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  183694:	0f 87 92 01 00 00    	ja     18382c <allocation_pmu_probe::main+0x1f8c>
  18369a:	4c 89 f6             	mov    %r14,%rsi
  18369d:	ba 01 00 00 00       	mov    $0x1,%edx
  1836a2:	4c 89 e7             	mov    %r12,%rdi
  1836a5:	e9 7c 01 00 00       	jmp    183826 <allocation_pmu_probe::main+0x1f86>
  1836aa:	48 89 c3             	mov    %rax,%rbx
  1836ad:	e9 e1 01 00 00       	jmp    183893 <allocation_pmu_probe::main+0x1ff3>
  1836b2:	e9 58 01 00 00       	jmp    18380f <allocation_pmu_probe::main+0x1f6f>
  1836b7:	e9 53 01 00 00       	jmp    18380f <allocation_pmu_probe::main+0x1f6f>
  1836bc:	48 89 c3             	mov    %rax,%rbx
  1836bf:	eb 54                	jmp    183715 <allocation_pmu_probe::main+0x1e75>
  1836c1:	48 89 c3             	mov    %rax,%rbx
  1836c4:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  1836c9:	e8 02 d7 ff ff       	call   180dd0 <core::ptr::drop_glue::<serde_json::error::Error>>
  1836ce:	e9 3f 01 00 00       	jmp    183812 <allocation_pmu_probe::main+0x1f72>
  1836d3:	ff 15 df 10 4c 00    	call   *0x4c10df(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  1836d9:	0f 0b                	ud2
  1836db:	48 89 c3             	mov    %rax,%rbx
  1836de:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1836e3:	e8 e8 d6 ff ff       	call   180dd0 <core::ptr::drop_glue::<serde_json::error::Error>>
  1836e8:	be 08 00 00 00       	mov    $0x8,%esi
  1836ed:	eb 18                	jmp    183707 <allocation_pmu_probe::main+0x1e67>
  1836ef:	ff 15 c3 10 4c 00    	call   *0x4c10c3(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  1836f5:	48 89 c3             	mov    %rax,%rbx
  1836f8:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1836fd:	e8 ce d6 ff ff       	call   180dd0 <core::ptr::drop_glue::<serde_json::error::Error>>
  183702:	be 09 00 00 00       	mov    $0x9,%esi
  183707:	ba 01 00 00 00       	mov    $0x1,%edx
  18370c:	4c 89 ef             	mov    %r13,%rdi
  18370f:	ff 15 73 10 4c 00    	call   *0x4c1073(%rip)        # 644788 <_DYNAMIC+0x270>
  183715:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  18371c:	00 
  18371d:	e8 4e 14 fd ff       	call   154b70 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, serde_json::value::Value> as core::ops::drop::Drop>::drop>
  183722:	e9 eb 00 00 00       	jmp    183812 <allocation_pmu_probe::main+0x1f72>
  183727:	ff 15 8b 10 4c 00    	call   *0x4c108b(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  18372d:	48 89 c3             	mov    %rax,%rbx
  183730:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  183735:	e8 36 d8 ff ff       	call   180f70 <core::ptr::drop_glue::<core::io::error::Error>>
  18373a:	e9 d3 00 00 00       	jmp    183812 <allocation_pmu_probe::main+0x1f72>
  18373f:	ff 15 73 10 4c 00    	call   *0x4c1073(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  183745:	48 89 c3             	mov    %rax,%rbx
  183748:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  18374f:	00 
  183750:	e8 2b cf ff ff       	call   180680 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  183755:	e9 df 00 00 00       	jmp    183839 <allocation_pmu_probe::main+0x1f99>
  18375a:	48 89 c3             	mov    %rax,%rbx
  18375d:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  183764:	00 
  183765:	e8 16 cf ff ff       	call   180680 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  18376a:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  183771:	00 
  183772:	e8 f9 d6 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  183777:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  18377c:	e8 ef d6 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  183781:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  183786:	e8 55 0a fd ff       	call   1541e0 <<alloc::collections::btree::map::BTreeMap<alloc::string::String, alloc::string::String> as core::ops::drop::Drop>::drop>
  18378b:	e9 e9 00 00 00       	jmp    183879 <allocation_pmu_probe::main+0x1fd9>
  183790:	48 89 c3             	mov    %rax,%rbx
  183793:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  18379a:	00 
  18379b:	e8 e0 ce ff ff       	call   180680 <core::ptr::drop_glue::<behavior_store::documents::StoreError>>
  1837a0:	e9 e1 00 00 00       	jmp    183886 <allocation_pmu_probe::main+0x1fe6>
  1837a5:	48 89 c3             	mov    %rax,%rbx
  1837a8:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  1837af:	00 
  1837b0:	e8 bb d7 ff ff       	call   180f70 <core::ptr::drop_glue::<core::io::error::Error>>
  1837b5:	e9 06 01 00 00       	jmp    1838c0 <allocation_pmu_probe::main+0x2020>
  1837ba:	ff 15 f8 0f 4c 00    	call   *0x4c0ff8(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  1837c0:	48 89 c3             	mov    %rax,%rbx
  1837c3:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  1837ca:	00 
  1837cb:	e8 a0 d7 ff ff       	call   180f70 <core::ptr::drop_glue::<core::io::error::Error>>
  1837d0:	41 bc 07 00 00 00    	mov    $0x7,%r12d
  1837d6:	e9 f7 00 00 00       	jmp    1838d2 <allocation_pmu_probe::main+0x2032>
  1837db:	ff 15 d7 0f 4c 00    	call   *0x4c0fd7(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  1837e1:	48 89 c3             	mov    %rax,%rbx
  1837e4:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  1837eb:	00 
  1837ec:	e8 7f d7 ff ff       	call   180f70 <core::ptr::drop_glue::<core::io::error::Error>>
  1837f1:	41 bc 07 00 00 00    	mov    $0x7,%r12d
  1837f7:	4c 8b b4 24 00 01 00 	mov    0x100(%rsp),%r14
  1837fe:	00 
  1837ff:	e9 1b 01 00 00       	jmp    18391f <allocation_pmu_probe::main+0x207f>
  183804:	ff 15 ae 0f 4c 00    	call   *0x4c0fae(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  18380a:	48 89 c3             	mov    %rax,%rbx
  18380d:	eb 1d                	jmp    18382c <allocation_pmu_probe::main+0x1f8c>
  18380f:	48 89 c3             	mov    %rax,%rbx
  183812:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  183817:	48 85 f6             	test   %rsi,%rsi
  18381a:	74 10                	je     18382c <allocation_pmu_probe::main+0x1f8c>
  18381c:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  183821:	ba 01 00 00 00       	mov    $0x1,%edx
  183826:	ff 15 5c 0f 4c 00    	call   *0x4c0f5c(%rip)        # 644788 <_DYNAMIC+0x270>
  18382c:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  183833:	00 
  183834:	e8 a7 c9 ff ff       	call   1801e0 <core::ptr::drop_glue::<behavior_store::store::Committed>>
  183839:	41 b6 01             	mov    $0x1,%r14b
  18383c:	48 8d bc 24 78 02 00 	lea    0x278(%rsp),%rdi
  183843:	00 
  183844:	e8 a7 d0 ff ff       	call   1808f0 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  183849:	eb 03                	jmp    18384e <allocation_pmu_probe::main+0x1fae>
  18384b:	48 89 c3             	mov    %rax,%rbx
  18384e:	48 8d bc 24 78 08 00 	lea    0x878(%rsp),%rdi
  183855:	00 
  183856:	e8 15 d6 ff ff       	call   180e70 <core::ptr::drop_glue::<serde_json::value::Value>>
  18385b:	48 83 bc 24 40 06 00 	cmpq   $0xffffffffffffffff,0x640(%rsp)
  183862:	00 ff 
  183864:	0f 94 c0             	sete   %al
  183867:	41 08 c6             	or     %al,%r14b
  18386a:	75 0d                	jne    183879 <allocation_pmu_probe::main+0x1fd9>
  18386c:	48 8d bc 24 40 06 00 	lea    0x640(%rsp),%rdi
  183873:	00 
  183874:	e8 77 d0 ff ff       	call   1808f0 <core::ptr::drop_glue::<behavior_store::documents::CommitBundle>>
  183879:	48 8d bc 24 a0 08 00 	lea    0x8a0(%rsp),%rdi
  183880:	00 
  183881:	e8 4a c5 ff ff       	call   17fdd0 <core::ptr::drop_glue::<behavior_store::store::Store<behavior_store::memory::InMemoryBackend>>>
  183886:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  18388d:	00 
  18388e:	e8 1d d7 ff ff       	call   180fb0 <core::ptr::drop_glue::<behavior_core::semantic::module::Module>>
  183893:	48 8d bc 24 e8 01 00 	lea    0x1e8(%rsp),%rdi
  18389a:	00 
  18389b:	e8 f0 c8 ff ff       	call   180190 <core::ptr::drop_glue::<allocation_pmu_probe::fixture::Case>>
  1838a0:	48 8b b4 24 10 01 00 	mov    0x110(%rsp),%rsi
  1838a7:	00 
  1838a8:	48 85 f6             	test   %rsi,%rsi
  1838ab:	74 13                	je     1838c0 <allocation_pmu_probe::main+0x2020>
  1838ad:	48 8b bc 24 18 01 00 	mov    0x118(%rsp),%rdi
  1838b4:	00 
  1838b5:	ba 01 00 00 00       	mov    $0x1,%edx
  1838ba:	ff 15 c8 0e 4c 00    	call   *0x4c0ec8(%rip)        # 644788 <_DYNAMIC+0x270>
  1838c0:	8b 7c 24 64          	mov    0x64(%rsp),%edi
  1838c4:	ff 15 8e 14 4c 00    	call   *0x4c148e(%rip)        # 644d58 <close@GLIBC_2.2.5>
  1838ca:	4c 8b a4 24 08 01 00 	mov    0x108(%rsp),%r12
  1838d1:	00 
  1838d2:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  1838d6:	ff 15 7c 14 4c 00    	call   *0x4c147c(%rip)        # 644d58 <close@GLIBC_2.2.5>
  1838dc:	eb 09                	jmp    1838e7 <allocation_pmu_probe::main+0x2047>
  1838de:	ff 15 d4 0e 4c 00    	call   *0x4c0ed4(%rip)        # 6447b8 <_DYNAMIC+0x2a0>
  1838e4:	48 89 c3             	mov    %rax,%rbx
  1838e7:	4c 8b b4 24 00 01 00 	mov    0x100(%rsp),%r14
  1838ee:	00 
  1838ef:	4d 85 e4             	test   %r12,%r12
  1838f2:	75 2b                	jne    18391f <allocation_pmu_probe::main+0x207f>
  1838f4:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  1838fb:	00 
  1838fc:	48 85 c0             	test   %rax,%rax
  1838ff:	74 16                	je     183917 <allocation_pmu_probe::main+0x2077>
  183901:	48 c1 e0 03          	shl    $0x3,%rax
  183905:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  183909:	ba 08 00 00 00       	mov    $0x8,%edx
  18390e:	4c 89 f7             	mov    %r14,%rdi
  183911:	ff 15 71 0e 4c 00    	call   *0x4c0e71(%rip)        # 644788 <_DYNAMIC+0x270>
  183917:	48 89 df             	mov    %rbx,%rdi
  18391a:	e8 a1 54 4b 00       	call   638dc0 <_Unwind_Resume@plt>
  18391f:	4d 8d 7e 08          	lea    0x8(%r14),%r15
  183923:	4c 8b 2d 5e 0e 4c 00 	mov    0x4c0e5e(%rip),%r13        # 644788 <_DYNAMIC+0x270>
  18392a:	eb 0d                	jmp    183939 <allocation_pmu_probe::main+0x2099>
  18392c:	0f 1f 40 00          	nopl   0x0(%rax)
  183930:	49 83 c7 18          	add    $0x18,%r15
  183934:	49 ff cc             	dec    %r12
  183937:	74 bb                	je     1838f4 <allocation_pmu_probe::main+0x2054>
  183939:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  18393d:	48 85 f6             	test   %rsi,%rsi
  183940:	74 ee                	je     183930 <allocation_pmu_probe::main+0x2090>
  183942:	49 8b 3f             	mov    (%r15),%rdi
  183945:	ba 01 00 00 00       	mov    $0x1,%edx
  18394a:	41 ff d5             	call   *%r13
  18394d:	eb e1                	jmp    183930 <allocation_pmu_probe::main+0x2090>
  18394f:	cc                   	int3
