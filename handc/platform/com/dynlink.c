/*-----------------------------------------------------------------*-C-*---
 * File:    handc/platform/com/dynlink.c
 *
 *          Copyright (C)1997 Donovan Kolbly <d.kolbly@rscheme.org>
 *          as part of the RScheme project, licensed for free use.
 *          See <http://www.rscheme.org/> for the latest information.
 *
 * File version:     1.7
 * File mod date:    2003-08-20 13:33:25
 * System build:     v0.7.3.4-b7u, 2007-05-30
 *
 * Purpose:          stub dynamic linking interface
 *------------------------------------------------------------------------*/

#include <stdio.h>
#include <rscheme/linktype.h>

typedef struct export_table *module_init_fn( void );

void *resolve_link_symbol( void *info, const char *sym )
{
  return NULL;
}

void *dynamic_link_file( const char *path )
{
  return NULL;
}

const char *dynamic_link_errors( void )
{
  return NULL;
}

void done_resolving( void *info )
{
}

void init_dynamic_link( const char *argv0 )
{
}
