---
layout: single
title: "Indexed addressing modes on the MOS 6502"
---

There are four indexed addressing modes on the MOS 6502. I've found the last one, `indirect indexed`, the most useful in my high-res graphics mode experiments on the Apple II+, but wanted to write about them all a bit. There are interactive examples at the end of this post (requires Javascript).

# Absolute Indexed

{% highlight nasm %}
STA $0100,Y
{% endhighlight %}

The absolute indexed addressing mode adds the contents of either the X or Y register to the memory address given. This can be used when you need to access or modify multiple memory addresses anywhere within the 16-bit address space. Note that the maximum index range is limited to 8 bits, the width of the 6502 registers.

Assuming the Y register contains `$08`, the above instruction will fetch the contents of `$0100+$08=$0108` and store it in the accumulator.

# Zero-page Indexed

{% highlight nasm %}
STA $F2,X
{% endhighlight %}

The zero-page indexed addressing mode is very similar to the above, absolute indexed mode. The difference is that there is only one byte for the first argument, which results in an address that is always in the zero page. If the calculated address will fall outside the zero page, it wraps.

Assuming that the X register contains `$0F`, the calculated address will be `$F2+$0F = $0101`. This falls outside of the zero-page, which will wrap to address `$01`.

Note that you should normally use the X register for this addressing mode. You can use the Y register, but it only works on the X register mnemonics (`LDX`, `STX`).

# Indexed Indirect

{% highlight nasm %}
LDA ($00, X)
{% endhighlight %}

The syntax for using the indexed indirect instruction is shown above. `$00` is an absolute address referring to memory address `0000`. X refers to the contents of the X register. Note that you cannot substitute X for Y while using indexed indirect. You likewise cannot use the X register with indirect indexed. Both this and the next addressing mode must be used with the accompanying register shown in these examples.

The contents of the X register will be added to the absolute address. Assuming X contains `$02`, the resulting address is `$00 + $02 = $02`. This is the memory location from which to fetch an address and retrieve the value stored in this address.

Note that this fetches a 16-bit address in little-endian format. For example, when reading the address at `$02`, it will use the `$02` value as the low-order byte and `$03` as the high-order byte.

{% highlight nasm %}
0002: 20 
0003: 01 
{% endhighlight %}

# Indirect Indexed

{% highlight nasm %}
STA ($00),Y
{% endhighlight %}

The last indexed addressing mode is confusingly called `indirect indexed`, but is different than the previous mode in the order of operations. In the previous addressing mode, the index was added before reading the address. In indirect indexed, the register is added after the indirect address is read. (Confusing? It's hard to explain too. 😵‍💫)

For example, `indexed indirect` would allow you to select a 16-bit address out of a table, while `indirect indexed` would allow you to iterate through memory *after* the 16-bit address is fetched. Paying close attention to the parentheses may help clarify this.

When provided with the zero-page address `$00`, this address is used as the low-order byte. The next address, in this example `$01`, is used as the high order byte. The contents of the y register are then added to this 16 bit address, allowing for indexed reference anywhere in the 6502's memory space.

The last interactive example uses this to loop through memory. Modifying the address in the zero-page would also allow you to iterate through more than 256 values.

# Summary

I found the `indirect indexed` mode the most useful when working with high-res graphics mode on the Apple II. A single page of HGR memory is `$2000` (or 8192!) bytes long. All of these modes are useful for different situations, though.

The below 6502 assembler/emulator has been adapted from the source of the [6502js](https://github.com/skilldrick/6502js) project, by [Nick Morgan](https://twitter.com/skilldrick). The modified source is available [here](/assets/6502js/assembler.js).

<div class="widget">
  <div class="examples">
    <h6>Examples:</h6>
    <input type="button" value="Absolute Indexed" class="reinitializeButton" onclick="absoluteIndexed()" />
    <input type="button" value="Zero Page Indexed" class="reinitializeButton" onclick="zeropageIndexed()" />
    <input type="button" value="Indexed Indirect" class="reinitializeButton" onclick="indexedIndirect()" />
    <input type="button" value="Indirect Indexed" class="reinitializeButton" onclick="indirectIndexed()" />
  </div>

  <div class="buttons">
    <h6>Assembler:</h6>
    <input type="button" value="Assemble" class="assembleButton" />
    <input type="button" value="Run" class="runButton" />
    <input type="button" value="Reset" class="resetButton" />
    <input type="button" value="Hexdump" class="hexdumpButton" />
    <input type="button" value="Disassemble" class="disassembleButton" />
    <input type="button" value="Notes" class="notesButton" />
  </div>


  <textarea id="exampleTextArea" class="code"></textarea>

  <canvas class="screen" width="160" height="160"></canvas>

  <div class="debugger">
    <input type="checkbox" class="debug inline-element" name="debug" />
    <label class="inline-element" for="debug">Debugger</label>
    <div class="minidebugger"></div>
    <div class="buttons">
      <input type="button" value="Step" class="stepButton" />
      <input type="button" value="Jump to ..." class="gotoButton" />
    </div>
  </div>

  <div class="monitorControls">
    <label class="inline-element" for="monitoring">Monitor</label>
    <input class="inline-element" id="monitorCheckbox" type="checkbox" class="monitoring" name="monitoring" />

    <label class="inline-element" for="start">Start: $</label>
    <input class="inline-element" type="text" value="0" class="start" name="start" />
    <label class="inline-element" for="length">Length: $</label>
    <input class="inline-element" type="text" value="0130" class="length" name="length" />
  </div>
  <div class="monitor"><pre><code></code></pre></div>
  <div class="messages"><pre><code></code></pre></div>
</div>


<script src="/assets/6502js/es5-shim.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="/assets/6502js/assembler.js"></script>
<script>
  window.onload = function() {
    absoluteIndexed();
    document.getElementById("monitorCheckbox").click()
  }

  function absoluteIndexed() {
    document.getElementById('exampleTextArea').value =
`; Store $08 in the Y register, and $BA in the accumulator
LDY #$08
LDA #$BA

; Use absolute indexed mode to store the accumulator
; in $0100+Y
STA $0100,Y
`
  }

  function zeropageIndexed() {
    document.getElementById('exampleTextArea').value =
`; Store $0F in the Y register, and $BA in the accumulator
LDX #$0F
LDA #$BA

; Use absolute indexed mode to store the accumulator
; in $F2+$0F, which wraps to $01 in the zero-page
STA $F2,X
`

  }

  function indexedIndirect() {
    document.getElementById('exampleTextArea').value = 
`; Store data in $0120 to illustrate later retrieval
LDA #$50
STA $0120

; Store memory address $0120 in location $02 and $03.
; This is stored in "reverse" order, as $20, $01, 
; because the 6502 is little-endian.
LDA #$20
STA $02
LDA #$01
STA $03
LDX #$02

; Indexed indirect memory addressing, which reads the
; memory address at $00 + $02 = $02, then reads the
; contents of that memory address ($02 and $03) and
; stores that value in the accumulator
LDA ($00, X)
`
  }

  function indirectIndexed() {
    document.getElementById('exampleTextArea').value =

`; Store the low-order memory address #$10 at location
; $00
LDA #$10
STA $00
; Store the working data #$BA in $03, to be referenced
; later for copies 🐑
LDA #$BA
STA $03

; Verify the Y register is initialized to 0
LDY #$00
; Start of infinite loop
LOOP:
; Load the #$BA we stashed away earlier into
; the accumulator
LDA $03
; Reference 16-bit address in the zero page, at $00
; and $01 . Only the low-order byte is provided at
; $00 , the next byte ($01) is implicitly used
; as the high-order byte
STA ($00),Y
; Increment the accumulator and jump back up
; to start the loop again
INY
JMP LOOP
`
  }
</script>

<link href="/assets/6502js/style.css" rel="stylesheet" type="text/css" />
<style>
  .inline-element {
    display: inline-block;
  }

  .debugger {
    height: 135px;
  }

  .monitor {
    height: 360px;
  }
</style>

