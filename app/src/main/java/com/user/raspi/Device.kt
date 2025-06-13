package com.user.raspi

data class Device(val name: String, val ip: String, val port: Int, var status: String = "Not connected")

