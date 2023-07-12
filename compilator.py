import tkinter as tk

opcode_table = {
    'addi': '001000',
        'add': '000000',
        'sub': '000000',
        'sll': '000000',
        'srl': '000000',
        'slt': '000000',
        'and': '000000',
        'or': '000000',
        'beq': '000100',
        'bne': '000101',
        'j': '000010',
        'sw': '101011',
        'lw': '100011'
    }

registers = {
    'zero': '00000',
    'at': '00001',
    'v0': '00010',
    'v1': '00011',
    'a0': '00100',
    'a1': '00101',
    'a2': '00110',
    'a3': '00111',
    't0': '01000',
    't1': '01001',
    't2': '01010',
    't3': '01011',
    't4': '01100',
    't5': '01101',
    't6': '01110',
    't7': '01111',
    's0': '10000',
    's1': '10001',
    's2': '10010',
    's3': '10011',
    's4': '10100',
    's5': '10101',
    's6': '10110',
    's7': '10111',
    't8': '11000',
    't9': '11001',
    'k0': '11010',
    'k1': '11011',
    'gp': '11100',
    'sp': '11101',
    'fp': '11110',
    'ra': '11111'
}

def mips_to_hex(instruction):
 
    parts = [p.replace(',', '') for p in instruction.split()]  

    opcode = opcode_table[parts[0]]

    match parts[0]:
        case 'j':
            address = format(int(parts[1]), '026b')
            hex_code = '{:08x}'.format(int(opcode + address, 2))
        case 'addi' | 'sw' | 'lw':
            rt = registers[parts[1]]
            rs = registers[parts[2]]
            immediate = format(int(parts[3]), '016b')
            hex_code = '{:08x}'.format(int(opcode + rs + rt + immediate, 2))
        case 'bne' | 'beq':
            rs = registers[parts[1]]
            rt = registers[parts[2]]
            offset = format(int(parts[3]), '016b')
            hex_code = '{:08x}'.format(int(opcode + rs + rt + offset, 2))
        case 'add':
            rd = registers[parts[1]]
            rs = registers[parts[2]]
            rt = registers[parts[3]]
            funct = '100000'  
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + '00000' + funct, 2))
        case 'sub':
            rd = registers[parts[1]]
            rs = registers[parts[2]]
            rt = registers[parts[3]]
            funct = '100010'  
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + '00000' + funct, 2))
        case 'sll': 
            rd = registers[parts[1]]
            rs = '00000'
            rt = registers[parts[2]]
            samt = format(int(parts[3]),'05b')
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + samt + '000000',2))
        case 'srl':
            rd = registers[parts[1]]
            rs = '00000'
            rt = registers[parts[2]]
            samt = format(int(parts[3]),'05b')
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + samt + '000010',2))
        case 'slt':
            rd = registers[parts[1]]
            rs = registers[parts[2]]
            rt = registers[parts[3]]
            funct = '101010'  
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + '00000' + funct, 2))
        case 'or':
            rd = registers[parts[1]]
            rs = registers[parts[2]]
            rt = registers[parts[3]]
            funct = '100101'  
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + '00000' + funct, 2)) 
        case 'and':
            rd = registers[parts[1]]
            rs = registers[parts[2]]
            rt = registers[parts[3]]
            funct = '100100'  
            hex_code = '{:08x}'.format(int(opcode + rs + rt + rd + '00000' + funct, 2))
    
    return hex_code

def compile():
    try:
        f = open("data.txt", "a")
        instrucion = input_field.get()
        hex_code = mips_to_hex(instrucion)
        result_field.insert(1.0, hex_code + '\n')
        f.write(hex_code + '\n')
        f.close()
    except:
        result_field.delete(1.0, tk.END)
        result_field.insert(1.0, 'Ai introdus instructiunea gresit.\nFormat: sw t1, t2, 15  sau add s1, zero, s2')

window = tk.Tk()
window.title("Mips Compiler")
window.geometry("500x500")

input_field = tk.Entry(window, font=('Arial', 15))
input_field.pack(padx=10,pady=50)

result_field= tk.Text(window, width=200, height=10, font=('Arial', 15))
result_field.pack(padx=50, pady=10)

button = tk.Button(window, text="Compile", command=compile)
button.config(width=10, height=2, bg="green",  font=("Arial", 12, "bold"))
button.pack(side=tk.TOP)

window.mainloop()

