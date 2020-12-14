var OZUSLClientDES128 = function(){
	this.strServerURL = ""
	this.setServerURL = function(url){
		strServerURL = url;
	};
	this.strServerIP = ""
	this.strServerIP = function(ip){
		strServerIP = iprl;
	};
	this.createSecureOutputStream = function(bytes, params){
		var dst = new ByteArray();
		var nCount = 0;
		var strParamName;
		for(strParamName in params){
			nCount++;
		}
		dst.writeInt(nCount);
		for(strParamName in params){
			var strParamValue = params[strParamName];
			this.writeString(dst, strParamName);
			this.writeString(dst, strParamValue);
		}
		var encBytes = new ByteArray();
		var enc = new CPC1Encode128("forcs@#$", encBytes);
		enc.write(bytes, 0, bytes.length);
		dst.writeBytes(encBytes, 0, encBytes.length);
		dst.position = 0;
		return dst;
	};
	this.createSecureInputStream = function(bytes, params){
   	var size = bytes.readInt();
   	for(var i=0; i<size; i++){
			var strParamName = this.readString(bytes);
			var strParamValue = this.readString(bytes);
			params[strParamName] = strParamValue;
		}
		var dst = new ByteArray();
		var des = new CPC1Decode128("forcs@#$", bytes);
		var desBytes = new ByteArray();
		des.read(desBytes, 0, bytes.length - bytes.position);
		dst.writeBytes(desBytes, 0, desBytes.length);
		dst.position = 0;
		return dst;
	};
	this.writeString = function(bytes, str)
	{
		var i;
		var strlen = str.length;
		
		bytes.writeInt(strlen);
		var v;
		
		for (i=0; i<strlen; i++)
		{
			v = str.charCodeAt(i);
			bytes.writeByte((v >>> 8) & 0xFF);
			bytes.writeByte((v >>> 0) & 0xFF);
		}
	};
	this.readString = function(bytes)
	{
		var strlen;
		var ch1, ch2;

		strlen = bytes.readInt();

		if (strlen == -1)
		{
			return "<NULL>";
		}
		else if (strlen < -1)
		{
			throw new Error("A malformed string has been read in a data input stream.");
		}
		
		var str = "";
		var position = bytes.position;

		for (var i = 0; i<strlen; i++)
		{
			ch1 = bytes[position+i*2];
			ch2 = bytes[position+i*2+1];
			
			if ((ch1 | ch2) < 0)
			{
				throw new Error("A malformed string has been read in a data input stream.");
			}
			
			str += String.fromCharCode((ch1 << 8) + (ch2 << 0));
		}
		bytes.position += strlen*2; 
		return str;
	};
};
var CPC1Decode128 = function(strPassword, _in1) {
	this.__constructor__CPC1Decode128 = function(strPassword, _in1) {
		this.ax = 0;
		this.bx = 0;
		this.cx = 0;
		this.dx = 0;
		this.si = 0;
		this.tmp = 0;
		this.x1a2 = 0;
		this.res = 0;
		this.i = 0;
		this.inter = 0;
		this.x1a0 = new Array();
		this.cfc = 0;
		this.cfd = 0;
		this.compte = 0;
		{
			this._in = _in1;
			this.cle = new ByteArray();
			this.cle.setLength(17);
			var strPass = new ByteArray();
			strPass.writeMultiByte(strPassword, "iso-8859-1");
			this.cle.writeBytes(strPass, 0, strPass.length > 16 ? 16 : strPass.length);
			this.cle.set(16, 0);
			this.clear();
		}
	};
	this.clear = function() {
		this.ax = 0;
		this.bx = 0;
		this.cx = 0;
		this.dx = 0;
		this.si = 0;
		this.tmp = 0;
		this.x1a2 = 0;
		this.res = 0;
		this.i = 0;
		this.inter = 0;
		this.cfc = 0;
		this.cfd = 0;
		this.compte = 0;
		for(var i = 0; i < 8; i++) {
			this.x1a0[i] = 0;
		}
	};
	this.readB = function() {
		var c = this._in.readByte();
		if(c == -1) {
			return -1;
		}
		this.Run();
		this.cfc = this.inter >>> 8;
		this.cfd = this.inter & 255;
		c = c ^ (this.cfc ^ this.cfd);
		for(this.compte = 0; this.compte <= 15; this.compte++) {
			this.cle.set(this.compte, this.cle.get(this.compte) ^ c);
		}
		return c;
	};
	this.read = function(b, off, len, b_size) {
		if(b === undefined) b = null;
		if(off === undefined) off = -1;
		if(len === undefined) len = -1;
		if(b_size === undefined) b_size = -1;
		{
			if((b == null) || this._in == null) {
				trace("Null point exception");
				return -1;
			}
			if(len < 1) {
				return 0;
			}
			this._in.readBytes(b, off, len);
			var rt = len;
			if(rt <= 0) {
				return rt;
			}
			{
				var c = 0;
				var i = 0;
				for(i = 0; i < rt; i++) {
					this.Run();
					this.cfc = this.inter >>> 0x08;
					this.cfd = this.inter & 0xff;
					c = b.get(i + off);
					c = c ^ (this.cfc ^ this.cfd);
					for(var j = 0; j < 16; j++) {
						this.cle.set(j, this.cle.get(j) ^ c);
					}
					b.set(i + off, c);
				}
			}
			return rt;
		}
	};
	this.available = function() {
		return 0;
	};
	this.Calc = function() {
		this.dx = this.x1a2 + this.i;
		this.ax = this.x1a0[this.i];
		this.cx = 0x015a;
		this.bx = 0x4e35;
		this.tmp = this.ax;
		this.ax = this.si;
		this.si = this.tmp;
		this.tmp = this.ax;
		this.ax = this.dx;
		this.dx = this.tmp;
		this.ax = this.ax * this.bx & 0xFFFF;
		this.tmp = this.ax;
		this.ax = this.cx;
		this.cx = this.tmp;
		if(this.ax != 0) {
			this.ax = (this.ax * this.si) & 0xFFFF;
			this.cx = (this.ax + this.cx) & 0xFFFF;
		}
		this.tmp = this.ax;
		this.ax = this.si;
		this.si = this.tmp;
		this.ax = (this.ax * this.bx) & 0xFFFF;
		this.dx = (this.cx + this.dx) & 0xFFFF;
		this.ax = this.ax + 1;
		this.x1a2 = this.dx;
		this.x1a0[this.i] = this.ax;
		this.res = this.ax ^ this.dx;
		this.i = this.i + 1;
	};
	this.Run = function() {
		this.x1a0[0] = (this.cle.get(0) * 256) + this.cle.get(1);
		this.Calc();
		this.inter = this.res;
		this.x1a0[1] = this.x1a0[0] ^ ((this.cle.get(2) * 256) + this.cle.get(3));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[2] = this.x1a0[1] ^ ((this.cle.get(4) * 256) + this.cle.get(5));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[3] = this.x1a0[2] ^ ((this.cle.get(6) * 256) + this.cle.get(7));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[4] = this.x1a0[3] ^ ((this.cle.get(8) * 256) + this.cle.get(9));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[5] = this.x1a0[4] ^ ((this.cle.get(10) * 256) + this.cle.get(11));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[6] = this.x1a0[5] ^ ((this.cle.get(12) * 256) + this.cle.get(13));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[7] = this.x1a0[6] ^ ((this.cle.get(14) * 256) + this.cle.get(15));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.i = 0;
	};
	this.__constructor__CPC1Decode128(strPassword, _in1);
};
var CPC1Encode128 = function(strPassword, _out1) {
	this.__constructor__CPC1Encode128 = function(strPassword, _out1) {
		this.ax = 0;
		this.bx = 0;
		this.cx = 0;
		this.dx = 0;
		this.si = 0;
		this.tmp = 0;
		this.x1a2 = 0;
		this.res = 0;
		this.i = 0;
		this.inter = 0;
		this.x1a0 = new Array();
		this.cfc = 0;
		this.cfd = 0;
		this.compte = 0;
		{
			this._out = _out1;
			this.x1a0.length = 8;
			this.cle = new ByteArray();
			this.cle.setLength(17);
			var strPass = new ByteArray();
			strPass.writeMultiByte(strPassword, "iso-8859-1");
			this.cle.writeBytes(strPass, 0, strPass.length > 16 ? 16 : strPass.length);
			this.cle.set(16, 0);
			this.clear();
		}
	};
	this.clear = function() {
		this.ax = 0;
		this.bx = 0;
		this.cx = 0;
		this.dx = 0;
		this.si = 0;
		this.tmp = 0;
		this.x1a2 = 0;
		this.res = 0;
		this.i = 0;
		this.inter = 0;
		this.cfc = 0;
		this.cfd = 0;
		this.compte = 0;
		for(var i = 0; i < 8; i++) {
			this.x1a0[i] = 0;
		}
	};
	this.writeB = function(b) {
		this.Run();
		this.cfc = this.inter >>> 8;
		this.cfd = this.inter & 255;
		for(this.compte = 0; this.compte <= 15; this.compte++) {
			this.cle.set(this.compte, this.cle.get(this.compte) ^ b);
		}
		b = b ^ (this.cfc ^ this.cfd);
		this._out.writeByte(b);
	};
	this.write = function(b, off, len) {
		if(b === undefined) b = null;
		if(off === undefined) off = -1;
		if(len === undefined) len = -1;
		{
			if((b == null) || this._out == null) {
				trace("Null point exception");
				return ;
			}
			if(len < 1) {
				return ;
			}
			var c = 0;
			var pBuff = new ByteArray();
			pBuff.setLength(len);
			for(var i = 0; i < len; i++) {
				this.Run();
				this.cfc = this.inter >>> 0x08;
				this.cfd = this.inter & 0xff;
				c = b.get(i + off);
				for(var j = 0; j < 16; j++) {
					this.cle.set(j, this.cle.get(j) ^ c);
				}
				c = c ^ (this.cfc ^ this.cfd);
				pBuff.set(i, c);
			}
			this._out.writeBytes(pBuff, 0, len);
			pBuff = null;
		}
	};
	this.flush = function() {};
	this.close = function() {};
	this.Calc = function() {
		this.dx = this.x1a2 + this.i;
		this.ax = this.x1a0[this.i];
		this.cx = 0x015a;
		this.bx = 0x4e35;
		this.tmp = this.ax;
		this.ax = this.si;
		this.si = this.tmp;
		this.tmp = this.ax;
		this.ax = this.dx;
		this.dx = this.tmp;
		this.ax = this.ax * this.bx & 0xFFFF;
		this.tmp = this.ax;
		this.ax = this.cx;
		this.cx = this.tmp;
		if(this.ax != 0) {
			this.ax = (this.ax * this.si) & 0xFFFF;
			this.cx = (this.ax + this.cx) & 0xFFFF;
		}
		this.tmp = this.ax;
		this.ax = this.si;
		this.si = this.tmp;
		this.ax = (this.ax * this.bx) & 0xFFFF;
		this.dx = (this.cx + this.dx) & 0xFFFF;
		this.ax = this.ax + 1;
		this.x1a2 = this.dx;
		this.x1a0[this.i] = this.ax;
		this.res = this.ax ^ this.dx;
		this.i = this.i + 1;
	};
	this.Run = function() {
		this.x1a0[0] = (this.cle.get(0) * 256) + this.cle.get(1);
		this.Calc();
		this.inter = this.res;
		this.x1a0[1] = this.x1a0[0] ^ ((this.cle.get(2) * 256) + this.cle.get(3));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[2] = this.x1a0[1] ^ ((this.cle.get(4) * 256) + this.cle.get(5));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[3] = this.x1a0[2] ^ ((this.cle.get(6) * 256) + this.cle.get(7));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[4] = this.x1a0[3] ^ ((this.cle.get(8) * 256) + this.cle.get(9));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[5] = this.x1a0[4] ^ ((this.cle.get(10) * 256) + this.cle.get(11));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[6] = this.x1a0[5] ^ ((this.cle.get(12) * 256) + this.cle.get(13));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.x1a0[7] = this.x1a0[6] ^ ((this.cle.get(14) * 256) + this.cle.get(15));
		this.Calc();
		this.inter = this.inter ^ this.res;
		this.i = 0;
	};
	this.__constructor__CPC1Encode128(strPassword, _out1);
};

