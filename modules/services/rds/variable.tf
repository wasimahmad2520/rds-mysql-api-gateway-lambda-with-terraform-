
variable "vpc"{
    type=any
    
}

variable "vpc_sgr"{
    type=any
}
variable "namespace"{
    type=string
    
}

variable "name"{
    type=string
    default="DBInstance"
}

variable "user_name"{
    type=string
    default="admin"
}

variable "password"{
    type=string
    default="admin&39%7"
}

variable "region"{
    type=string
    /* default="us-west-2" */
}




